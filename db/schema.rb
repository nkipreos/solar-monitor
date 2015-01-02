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

ActiveRecord::Schema.define(version: 20150102200323) do

  create_table "accounts", force: true do |t|
    t.string   "name"
    t.string   "api_key"
    t.string   "timezone"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "remote_devices", force: true do |t|
    t.integer  "account_id"
    t.string   "name"
    t.string   "unique_id"
    t.string   "location_name"
    t.decimal  "latitude",      precision: 9, scale: 6
    t.decimal  "longitude",     precision: 9, scale: 6
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "remote_devices", ["account_id"], name: "index_remote_devices_on_account_id", using: :btree

  create_table "stream_data", force: true do |t|
    t.integer  "stream_id"
    t.float    "value",       limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "measured_at"
  end

  add_index "stream_data", ["stream_id"], name: "index_stream_data_on_stream_id", using: :btree

  create_table "streams", force: true do |t|
    t.integer  "remote_device_id"
    t.string   "stream_type"
    t.string   "unique_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  add_index "streams", ["remote_device_id"], name: "index_streams_on_remote_device_id", using: :btree

  create_table "user_account_relations", force: true do |t|
    t.integer  "user_id"
    t.integer  "account_id"
    t.string   "relation_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_account_relations", ["account_id"], name: "index_user_account_relations_on_account_id", using: :btree
  add_index "user_account_relations", ["user_id"], name: "index_user_account_relations_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "username"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
