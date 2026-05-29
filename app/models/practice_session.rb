class PracticeSession < ApplicationRecord
  QUESTION_COUNT = 4

  has_many :practice_questions, dependent: :destroy

  validates :unit, inclusion: { in: Problem::CURRICULUM_UNITS }
  validates :level, inclusion: { in: 1..5 }
  validates :current_position, inclusion: { in: 1..QUESTION_COUNT }

  scope :recent, -> { order(created_at: :desc) }

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
end
