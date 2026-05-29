class AddLevelToProblems < ActiveRecord::Migration[7.1]
  def change
    add_column :problems, :level, :integer, null: false, default: 1
  end
end
