class CreateProblems < ActiveRecord::Migration[7.1]
  def change
    create_table :problems do |t|
      t.string :title
      t.string :unit
      t.text :question
      t.string :answer
      t.text :hint

      t.timestamps
    end
  end
end
