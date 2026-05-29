class CreateAttempts < ActiveRecord::Migration[7.1]
  def change
    create_table :attempts do |t|
      t.references :problem, foreign_key: true
      t.string :submitted_answer, null: false
      t.string :result, null: false
      t.string :reflection_reason, null: false
      t.integer :confidence, null: false
      t.text :note

      t.timestamps
    end
  end
end
