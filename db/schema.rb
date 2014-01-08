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

ActiveRecord::Schema.define(version: 20140108024448) do

  create_table "texts", force: true do |t|
    t.string   "app",          limit: 100
    t.string   "locale",       limit: 10
    t.string   "context",      limit: 100
    t.string   "name",         limit: 100
    t.string   "mime_type",    limit: 100
    t.string   "usage",        limit: 100, default: ""
    t.text     "result"
    t.integer  "lock_version",             default: 0,     null: false
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.boolean  "markdown",                 default: false, null: false
    t.text     "html"
    t.integer  "created_by"
    t.integer  "updated_by"
  end

  add_index "texts", ["app", "context", "name", "locale"], name: "index_texts_on_app_and_context_and_name_and_locale", unique: true
  add_index "texts", ["app", "locale"], name: "index_texts_on_app_and_locale"
  add_index "texts", ["created_at"], name: "index_texts_on_created_at"
  add_index "texts", ["updated_at"], name: "index_texts_on_updated_at"

end
