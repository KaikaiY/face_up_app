class AddReflectionFieldsToAttempts < ActiveRecord::Migration[7.1]
  def change
    add_column :attempts, :thought_process, :text
    add_column :attempts, :next_focus, :string
  end
end
