# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20140205213129) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "items", force: true do |t|
    t.integer "user_id"
    t.integer "total_id"
    t.integer "count"
  end

  create_table "totals", force: true do |t|
    t.integer "user_id"
    t.integer "total"
  end

  create_table "users", force: true do |t|
    t.string "name"
  end

  add_foreign_key "items", "totals", name: "items_total_id_fk"
  add_foreign_key "items", "users", name: "items_user_id_fk"

  add_foreign_key "totals", "users", name: "totals_user_id_fk"

end
