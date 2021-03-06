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

ActiveRecord::Schema.define(version: 16) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: true do |t|
    t.string   "name"
    t.string   "surname"
    t.string   "email"
    t.string   "crypted_password"
    t.string   "role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "jobs", force: true do |t|
    t.text     "name"
    t.text     "source_connection_string"
    t.text     "destination_connection_string"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",                        default: false, null: false
  end

  create_table "table_copies", force: true do |t|
    t.text     "text"
    t.integer  "rows_copied"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "table_id"
  end

  create_table "tables", force: true do |t|
    t.integer  "job_id"
    t.text     "source_name"
    t.text     "destination_name"
    t.text     "primary_key"
    t.text     "updated_key"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "last_copied_at"
    t.datetime "max_updated_key"
    t.integer  "max_primary_key",              limit: 8
    t.datetime "reset_updated_key"
    t.integer  "time_travel_scan_back_period"
    t.boolean  "delete_on_reset"
    t.boolean  "disabled"
    t.text     "table_copy_type"
  end

end
