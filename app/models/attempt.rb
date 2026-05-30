class Attempt < ApplicationRecord
  belongs_to :problem, optional: true
  belongs_to :practice_question, optional: true

  RESULTS = {
    "correct" => "正解",
    "incorrect" => "もう一歩"
  }.freeze

  REFLECTION_REASONS = {
    "can_explain" => "説明できる",
    "partly_understood" => "途中まではわかった",
    "lucky_guess" => "なんとなく当たった",
    "felt_easier" => "前より楽にできた",
    "calculation_mistake" => "計算ミスをした",
    "sign_confusion" => "符号で迷った",
    "misread" => "問題文を読み違えた",
    "unknown_method" => "解き方がわからなかった"
  }.freeze

  CORRECT_REFLECTION_REASONS = %w[can_explain partly_understood lucky_guess felt_easier].freeze
  INCORRECT_REFLECTION_REASONS = %w[calculation_mistake sign_confusion misread unknown_method].freeze

  NEXT_FOCUS_OPTIONS = {
    "check_sign_first" => "符号を先に見る",
    "write_steps" => "途中式を書く",
    "try_small_numbers" => "小さい数字で考える",
    "reread_question" => "問題文をもう一度読む",
    "explain_before_next" => "次は説明してから答える"
  }.freeze

  validates :submitted_answer, :result, :reflection_reason, :thought_process, :next_focus, presence: true
  validates :problem, presence: true, unless: :practice_question
  validates :practice_question, presence: true, unless: :problem
  validates :question_snapshot, :answer_snapshot, :unit, :level, presence: true, if: :practice_question
  validates :result, inclusion: { in: RESULTS.keys }
  validates :reflection_reason, inclusion: { in: REFLECTION_REASONS.keys }
  validates :next_focus, inclusion: { in: NEXT_FOCUS_OPTIONS.keys }
  validates :confidence, inclusion: { in: 1..5 }

  scope :recent, -> { includes(:problem).order(created_at: :desc) }

  def self.reflection_reasons_for(result)
    keys = result == "correct" ? CORRECT_REFLECTION_REASONS : INCORRECT_REFLECTION_REASONS
    REFLECTION_REASONS.slice(*keys)
  end

  def result_label
    RESULTS.fetch(result)
  end

  def reflection_reason_label
    REFLECTION_REASONS.fetch(reflection_reason)
  end

  def next_focus_label
    NEXT_FOCUS_OPTIONS.fetch(next_focus, "-")
  end

  def display_title
    problem&.title || "レベル#{level} #{unit}"
  end

  def display_answer
    problem&.answer || answer_snapshot
  end

  def display_unit
    problem&.unit || unit
  end

  def display_level
    problem&.level || level
  end

  def display_question
    problem&.question || question_snapshot
  end
end
