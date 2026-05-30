class PracticeSession < ApplicationRecord
  QUESTION_COUNT = 4

  has_many :practice_questions, dependent: :destroy

  validates :unit, inclusion: { in: Problem::CURRICULUM_UNITS }
  validates :level, inclusion: { in: 1..5 }
  validates :current_position, inclusion: { in: 1..QUESTION_COUNT }

  scope :recent, -> { order(created_at: :desc) }
  scope :with_attempts, -> { joins(practice_questions: :attempt).distinct }

  def self.start_for!(unit:, level:)
    create!(unit: unit, level: level, current_position: 1).tap do |session|
      PracticeQuestionGenerator.generate(unit: unit, level: level, count: QUESTION_COUNT).each.with_index(1) do |attributes, position|
        session.practice_questions.create!(attributes.merge(position: position))
      end
    end
  end

  def current_question
    practice_questions.order(:position).find_by(position: current_position)
  end

  def complete?
    completed_at.present?
  end

  def advance!
    if current_position >= QUESTION_COUNT
      update!(completed_at: Time.current)
    else
      increment!(:current_position)
    end
  end

  def correct_count
    practice_questions.joins(:attempt).where(attempts: { result: "correct" }).count
  end

  def incorrect_count
    answered_count - correct_count
  end

  def answered_count
    practice_questions.joins(:attempt).count
  end

  def main_reflection_reason_label
    reason = main_reflection_reason
    reason.present? ? Attempt::REFLECTION_REASONS.fetch(reason) : "-"
  end

  def attempts
    Attempt.joins(:practice_question).where(practice_questions: { practice_session_id: id })
  end

  def average_confidence
    return 0 if answered_count.zero?

    attempts.average(:confidence).to_f.round(1)
  end

  def summary
    reason = main_reflection_reason

    {
      correct_count: correct_count,
      answered_count: answered_count,
      incorrect_count: incorrect_count,
      average_confidence: average_confidence,
      main_reason_label: main_reflection_reason_label,
      recommendation: recommendation_for(reason),
      encouragement: encouragement_for(reason)
    }
  end

  private

  def main_reflection_reason
    attempts.group(:reflection_reason).order(Arel.sql("COUNT(*) DESC")).limit(1).count.keys.first
  end

  def recommendation_for(reason)
    return "まずは4問すべて解いて、記録をそろえましょう。" if answered_count < QUESTION_COUNT
    return "次のレベルへ進んでよさそうです。" if correct_count == QUESTION_COUNT && reason == "can_explain"
    return "次のレベルへ進んで、少し難しい問題で確かめましょう。" if correct_count >= 3 && average_confidence >= 3.0 && reason != "lucky_guess"
    return "同じレベルをもう一度やって、説明できるか確かめましょう。" if reason == "lucky_guess"
    return "同じレベルで、符号と途中式をゆっくり確認しましょう。" if reason == "calculation_mistake"
    return "同じレベルで、符号を先に見る練習をもう一度しましょう。" if reason == "sign_confusion"
    return "次に進む前に、このレベルをヒントを見ながらもう一度やりましょう。" if reason == "unknown_method"

    correct_count >= 3 ? "もう一度だけ確認してから次へ進みましょう。" : "同じレベルをもう一度やりましょう。"
  end

  def encouragement_for(reason)
    return "説明できる問題が増えています。この調子で次の段差に進めそうです。" if correct_count == QUESTION_COUNT && reason == "can_explain"
    return "考え方は近づいています。最後に符号や計算を見直す習慣を足すと安定しそうです。" if reason == "calculation_mistake"
    return "符号で迷ったことに気づけています。先に符号だけ決めると解きやすくなりそうです。" if reason == "sign_confusion"
    return "当たった理由を言葉にできると、次も同じように解けます。" if reason == "lucky_guess"
    return "解き方が見えない問題は、戻る場所がわかったサインです。小さい数字で確認しましょう。" if reason == "unknown_method"
    return "問題文の見落としに気づけています。読む場所を決めるだけでかなり変わりそうです。" if reason == "misread"

    "できたところと迷ったところが記録できています。次は迷った理由をひとつ減らしましょう。"
  end
end
