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

ActiveRecord::Schema.define(version: 20160805224109) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "articles", force: :cascade do |t|
    t.string   "title"
    t.string   "url"
    t.text     "text"
    t.datetime "date"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "news_image_file_name"
    t.string   "news_image_content_type"
    t.integer  "news_image_file_size"
    t.datetime "news_image_updated_at"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "matches", force: :cascade do |t|
    t.string   "home_team"
    t.string   "away_team"
    t.string   "competition"
    t.integer  "h1"
    t.integer  "h2"
    t.integer  "h3"
    t.integer  "h_ot"
    t.integer  "a1"
    t.integer  "a2"
    t.integer  "a3"
    t.integer  "a_ot"
    t.datetime "datetime"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "players", force: :cascade do |t|
    t.string   "name"
    t.string   "surname"
    t.date     "birthdate"
    t.integer  "ep_id"
    t.string   "nationality"
    t.integer  "weight"
    t.integer  "height"
    t.string   "contract"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "number"
    t.string   "position"
    t.string   "player_image_file_name"
    t.string   "player_image_content_type"
    t.integer  "player_image_file_size"
    t.datetime "player_image_updated_at"
  end

  create_table "schedules", force: :cascade do |t|
    t.boolean  "articles_running"
    t.integer  "articles_interval"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "matches_interval"
    t.boolean  "matches_running"
  end

  create_table "teams", force: :cascade do |t|
    t.string   "name"
    t.string   "competition"
    t.integer  "wins"
    t.integer  "ot_wins"
    t.integer  "ot_losses"
    t.integer  "losses"
    t.integer  "goals_for"
    t.integer  "goals_against"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

end
