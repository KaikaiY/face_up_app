class PracticeQuestion < ApplicationRecord
  belongs_to :practice_session
  has_one :attempt, dependent: :nullify

  validates :position, inclusion: { in: 1..PracticeSession::QUESTION_COUNT }
  validates :position, uniqueness: { scope: :practice_session_id }
  validates :question, :answer, presence: true

  def correct_answer?(submitted_answer)
    Problem.new(answer: answer).correct_answer?(submitted_answer)
  end
end
