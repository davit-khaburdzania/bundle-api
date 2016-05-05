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

ActiveRecord::Schema.define(version: 20160409015438) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "auth_providers", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "uid",        limit: 8
    t.string   "provider"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "auth_providers", ["user_id"], name: "index_auth_providers_on_user_id", using: :btree

  create_table "bundles", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "creator_id"
    t.integer  "collection_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "favorites_count", default: 0
    t.integer  "links_count",     default: 0
    t.string   "slug"
    t.integer  "shares_count",    default: 0
  end

  add_index "bundles", ["slug"], name: "index_bundles_on_slug", unique: true, using: :btree

  create_table "collections", force: :cascade do |t|
    t.string   "name"
    t.integer  "creator_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "favorites_count", default: 0
    t.integer  "bundles_count",   default: 0
    t.string   "slug"
    t.integer  "shares_count",    default: 0
  end

  add_index "collections", ["slug"], name: "index_collections_on_slug", unique: true, using: :btree

  create_table "favorites", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "favoritable_id"
    t.string   "favoritable_type"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "favorites", ["user_id"], name: "index_favorites_on_user_id", using: :btree

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "invites", force: :cascade do |t|
    t.integer  "inviter_id"
    t.integer  "invited_id"
    t.integer  "invitable_id"
    t.string   "invitable_type"
    t.string   "email"
    t.text     "token"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "permission_id"
  end

  create_table "links", force: :cascade do |t|
    t.integer  "creator_id"
    t.integer  "bundle_id"
    t.string   "title"
    t.text     "description"
    t.string   "image"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "url"
  end

  add_index "links", ["bundle_id"], name: "index_links_on_bundle_id", using: :btree

  create_table "permissions", force: :cascade do |t|
    t.string "name"
  end

  create_table "shares", force: :cascade do |t|
    t.integer  "sharable_id"
    t.string   "sharable_type"
    t.integer  "user_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "permission_id"
  end

  create_table "url_shares", force: :cascade do |t|
    t.integer  "sharable_by_url_id"
    t.string   "sharable_by_url_type"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "user_id"
    t.integer  "permission_id"
  end

  add_index "url_shares", ["user_id"], name: "index_url_shares_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "image"
    t.string   "username"
    t.string   "about"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text     "auth_token"
  end

  add_foreign_key "auth_providers", "users"
  add_foreign_key "favorites", "users"
  add_foreign_key "links", "bundles"
  add_foreign_key "url_shares", "users"
end
