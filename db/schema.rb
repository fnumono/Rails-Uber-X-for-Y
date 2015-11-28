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

ActiveRecord::Schema.define(version: 20151128155411) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "clients", force: :cascade do |t|
    t.string   "provider",               default: "email", null: false
    t.string   "uid",                    default: "",      null: false
    t.string   "encrypted_password",     default: "",      null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "name"
    t.string   "nickname"
    t.string   "image"
    t.string   "email"
    t.json     "tokens"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "fname"
    t.string   "lname"
    t.string   "address1"
    t.string   "address2"
    t.string   "phone1"
    t.string   "phone2"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  add_index "clients", ["email"], name: "index_clients_on_email", using: :btree
  add_index "clients", ["reset_password_token"], name: "index_clients_on_reset_password_token", unique: true, using: :btree
  add_index "clients", ["uid", "provider"], name: "index_clients_on_uid_and_provider", unique: true, using: :btree

  create_table "providers", force: :cascade do |t|
    t.string   "provider",                    default: "email", null: false
    t.string   "uid",                         default: "",      null: false
    t.string   "encrypted_password",          default: "",      null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",               default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "name"
    t.string   "nickname"
    t.string   "image"
    t.string   "email"
    t.json     "tokens"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "fname"
    t.string   "lname"
    t.string   "address1"
    t.string   "address2"
    t.string   "phone1"
    t.string   "phone2"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.string   "driverlicense_file_name"
    t.string   "driverlicense_content_type"
    t.integer  "driverlicense_file_size"
    t.datetime "driverlicense_updated_at"
    t.string   "proofinsurance_file_name"
    t.string   "proofinsurance_content_type"
    t.integer  "proofinsurance_file_size"
    t.datetime "proofinsurance_updated_at"
  end

  add_index "providers", ["email"], name: "index_providers_on_email", using: :btree
  add_index "providers", ["reset_password_token"], name: "index_providers_on_reset_password_token", unique: true, using: :btree
  add_index "providers", ["uid", "provider"], name: "index_providers_on_uid_and_provider", unique: true, using: :btree

  create_table "settings", force: :cascade do |t|
    t.integer  "provider_id"
    t.datetime "a1099"
    t.datetime "noncompete"
    t.datetime "confidentiality"
    t.datetime "delivery"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "settings", ["provider_id"], name: "index_settings_on_provider_id", using: :btree

  create_table "superadmins", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "superadmins", ["email"], name: "index_superadmins_on_email", unique: true, using: :btree
  add_index "superadmins", ["reset_password_token"], name: "index_superadmins_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "settings", "providers"
end
