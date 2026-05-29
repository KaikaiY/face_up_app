class AddPracticeFieldsToAttempts < ActiveRecord::Migration[7.1]
  def change
    add_reference :attempts, :practice_question, foreign_key: true, index: { unique: true, where: "practice_question_id IS NOT NULL" }
    add_column :attempts, :question_snapshot, :text
    add_column :attempts, :answer_snapshot, :string
    add_column :attempts, :unit, :string
    add_column :attempts, :level, :integer
  end
end
