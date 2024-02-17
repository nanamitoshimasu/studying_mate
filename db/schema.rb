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

ActiveRecord::Schema[7.0].define(version: 2024_02_17_005424) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "break_times", force: :cascade do |t|
    t.datetime "break_start_time", null: false
    t.datetime "break_end_time"
    t.bigint "timer_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["timer_id"], name: "index_break_times_on_timer_id"
    t.index ["user_id"], name: "index_break_times_on_user_id"
  end

  create_table "team_attendances", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_team_attendances_on_team_id"
    t.index ["user_id", "team_id"], name: "index_team_attendances_on_user_id_and_team_id", unique: true
    t.index ["user_id"], name: "index_team_attendances_on_user_id"
  end

  create_table "teams", force: :cascade do |t|
    t.integer "target_time", null: false
    t.datetime "start_date", null: false
    t.datetime "end_date", null: false
    t.integer "capacity", null: false
    t.string "thumbnail"
    t.text "description"
    t.string "title"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0, null: false
    t.datetime "deadline", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["user_id"], name: "index_teams_on_user_id"
  end

  create_table "timers", force: :cascade do |t|
    t.datetime "start_time", null: false
    t.datetime "end_time"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "team_id"
    t.index ["team_id"], name: "index_timers_on_team_id"
    t.index ["user_id"], name: "index_timers_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "avatar"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "uid"
    t.string "provider"
  end

  add_foreign_key "break_times", "timers"
  add_foreign_key "break_times", "users"
  add_foreign_key "team_attendances", "teams"
  add_foreign_key "team_attendances", "users"
  add_foreign_key "teams", "users"
  add_foreign_key "timers", "teams"
  add_foreign_key "timers", "users"
end
