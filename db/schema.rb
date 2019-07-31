# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_07_31_000246) do

  create_table "actions", force: :cascade do |t|
    t.text "action_name"
    t.text "selection_type"
    t.boolean "target_self"
    t.integer "mp_cost"
    t.decimal "damage_multiplier"
    t.decimal "stun_chance"
    t.decimal "atk_buff"
    t.decimal "def_buff"
    t.decimal "heal_value"
    t.integer "aggro_change"
    t.text "job"
  end

  create_table "adventurers", force: :cascade do |t|
    t.string "name"
    t.string "job"
    t.integer "atk"
    t.integer "defense"
    t.integer "max_HP"
    t.integer "max_MP"
    t.integer "skill1_id"
    t.integer "skill2_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "monsters", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "atk"
    t.integer "defense"
    t.integer "max_HP"
    t.integer "level"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
