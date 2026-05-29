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
    "calculation_mistake" => "計算ミスをした",
    "misread" => "問題文を読み違えた",
    "unknown_method" => "解き方がわからなかった"
  }.freeze

  validates :submitted_answer, :result, :reflection_reason, presence: true
  validates :problem, presence: true, unless: :practice_question
  validates :practice_question, presence: true, unless: :problem
  validates :question_snapshot, :answer_snapshot, :unit, :level, presence: true, if: :practice_question
  validates :result, inclusion: { in: RESULTS.keys }
  validates :reflection_reason, inclusion: { in: REFLECTION_REASONS.keys }
  validates :confidence, inclusion: { in: 1..5 }

  scope :recent, -> { includes(:problem).order(created_at: :desc) }

  def result_label
    RESULTS.fetch(result)
  end

  def reflection_reason_label
    REFLECTION_REASONS.fetch(reflection_reason)
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
end
