class CreateProblems < ActiveRecord::Migration[7.1]
  def change
    create_table :problems do |t|
      t.string :title, null: false
      t.string :unit, null: false
      t.text :question, null: false
      t.string :answer, null: false
      t.text :hint

      t.timestamps
    end
  end
end
