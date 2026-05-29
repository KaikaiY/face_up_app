# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2026_05_28_075852) do
  create_table "attempts", force: :cascade do |t|
    t.integer "problem_id"
    t.string "submitted_answer", null: false
    t.string "result", null: false
    t.string "reflection_reason", null: false
    t.integer "confidence", null: false
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "practice_question_id"
    t.text "question_snapshot"
    t.string "answer_snapshot"
    t.string "unit"
    t.integer "level"
    t.index ["practice_question_id"], name: "index_attempts_on_practice_question_id", unique: true, where: "practice_question_id IS NOT NULL"
    t.index ["problem_id"], name: "index_attempts_on_problem_id"
  end

  create_table "practice_questions", force: :cascade do |t|
    t.integer "practice_session_id", null: false
    t.integer "position", null: false
    t.text "question", null: false
    t.string "answer", null: false
    t.text "hint"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["practice_session_id", "position"], name: "index_practice_questions_on_practice_session_id_and_position", unique: true
    t.index ["practice_session_id"], name: "index_practice_questions_on_practice_session_id"
  end

  create_table "practice_sessions", force: :cascade do |t|
    t.string "unit", null: false
    t.integer "level", null: false
    t.integer "current_position", default: 1, null: false
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["unit", "level"], name: "index_practice_sessions_on_unit_and_level"
  end

  create_table "problems", force: :cascade do |t|
    t.string "title", null: false
    t.string "unit", null: false
    t.text "question", null: false
    t.string "answer", null: false
    t.text "hint"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "level", default: 1, null: false
  end

  add_foreign_key "attempts", "practice_questions"
  add_foreign_key "attempts", "problems"
  add_foreign_key "practice_questions", "practice_sessions"
end
