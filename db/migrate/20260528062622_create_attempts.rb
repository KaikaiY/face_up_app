class CreateAttempts < ActiveRecord::Migration[7.1]
  def change
    create_table :attempts do |t|
      t.references :problem, null: false, foreign_key: true
      t.string :submitted_answer
      t.string :result
      t.string :reflection_reason
      t.integer :confidence
      t.text :note

      t.timestamps
    end
  end
end
