class CreatePracticeSessions < ActiveRecord::Migration[7.1]
  def change
    create_table :practice_sessions do |t|
      t.string :unit, null: false
      t.integer :level, null: false
      t.integer :current_position, null: false, default: 1
      t.datetime :completed_at

      t.timestamps
    end

    add_index :practice_sessions, [:unit, :level]
  end
end
