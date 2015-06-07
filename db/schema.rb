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

ActiveRecord::Schema.define(version: 20150607031745) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "auctions", force: :cascade do |t|
    t.integer  "item_id"
    t.integer  "user_id"
    t.integer  "current_price"
    t.boolean  "is_active"
    t.integer  "best_bidder_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "auctions", ["item_id"], name: "index_auctions_on_item_id", using: :btree
  add_index "auctions", ["user_id"], name: "index_auctions_on_user_id", using: :btree

  create_table "items", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "item_name"
    t.integer  "start_price"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "items", ["user_id"], name: "index_items_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.integer  "budget"
    t.text     "owned_item_ids", default: [],              array: true
    t.integer  "blocked_budget"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_foreign_key "auctions", "items"
  add_foreign_key "auctions", "users"
  add_foreign_key "items", "users"
end
