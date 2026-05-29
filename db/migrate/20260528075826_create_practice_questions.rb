class CreatePracticeQuestions < ActiveRecord::Migration[7.1]
  def change
    create_table :practice_questions do |t|
      t.references :practice_session, null: false, foreign_key: true
      t.integer :position, null: false
      t.text :question, null: false
      t.string :answer, null: false
      t.text :hint

      t.timestamps
    end

    add_index :practice_questions, [:practice_session_id, :position], unique: true
  end
end
