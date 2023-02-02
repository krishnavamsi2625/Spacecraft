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

ActiveRecord::Schema[7.0].define(version: 2023_02_01_134400) do
  create_table "launch_vehicles", force: :cascade do |t|
    t.string "name"
    t.integer "weight"
    t.string "owned_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "payload"
    t.boolean "reusable"
  end

  create_table "launches", force: :cascade do |t|
    t.datetime "launch_date"
    t.integer "launch_vehicle_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["launch_vehicle_id"], name: "index_launches_on_launch_vehicle_id"
  end

  create_table "spacecrafts", force: :cascade do |t|
    t.string "name"
    t.integer "weight"
    t.date "expected_launch_date"
    t.string "owned_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "launch_id"
    t.index ["launch_id"], name: "index_spacecrafts_on_launch_id"
  end

  add_foreign_key "launches", "launch_vehicles"
end
