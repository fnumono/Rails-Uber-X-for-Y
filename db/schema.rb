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

ActiveRecord::Schema.define(version: 20160830060619) do

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

  create_table "admins", force: :cascade do |t|
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
    t.integer  "zoom_office_id"
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree
  add_index "admins", ["zoom_office_id"], name: "index_admins_on_zoom_office_id", using: :btree

  create_table "charges", force: :cascade do |t|
    t.integer  "amount"
    t.integer  "coupon_id"
    t.integer  "stripe_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "client_settings", force: :cascade do |t|
    t.integer  "client_id"
    t.boolean  "status_update_email",   default: true
    t.boolean  "status_update_sms",     default: true
    t.boolean  "provider_update_email", default: true
    t.boolean  "provider_update_sms",   default: true
    t.integer  "hours",                 default: 1
    t.boolean  "hours_email",           default: true
    t.boolean  "hours_sms",             default: true
    t.float    "funds",                 default: 0.0
    t.boolean  "funds_email",           default: true
    t.boolean  "funds_sms",             default: true
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  add_index "client_settings", ["client_id"], name: "index_client_settings_on_client_id", using: :btree

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
    t.string   "state"
    t.string   "city"
    t.string   "zip"
    t.integer  "zoom_office_id"
    t.boolean  "banned",                 default: false
  end

  add_index "clients", ["email"], name: "index_clients_on_email", using: :btree
  add_index "clients", ["reset_password_token"], name: "index_clients_on_reset_password_token", unique: true, using: :btree
  add_index "clients", ["uid", "provider"], name: "index_clients_on_uid_and_provider", unique: true, using: :btree
  add_index "clients", ["zoom_office_id"], name: "index_clients_on_zoom_office_id", using: :btree

  create_table "coupons", force: :cascade do |t|
    t.string   "code"
    t.integer  "discount_percent"
    t.datetime "expires_at"
    t.string   "description"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "escrow_hours", force: :cascade do |t|
    t.float    "hoursavail",  default: 0.0
    t.float    "hoursused",   default: 0.0
    t.float    "escrowavail", default: 0.0
    t.float    "escrowused",  default: 0.0
    t.integer  "client_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "escrow_hours", ["client_id"], name: "index_escrow_hours_on_client_id", using: :btree

  create_table "fees", force: :cascade do |t|
    t.integer  "percent"
    t.integer  "cent",       default: 0
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.integer  "notify_type", default: 0
    t.string   "name"
    t.string   "text"
    t.integer  "client_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "notifications", ["client_id"], name: "index_notifications_on_client_id", using: :btree

  create_table "payments", force: :cascade do |t|
    t.integer  "client_id"
    t.float    "purchase_hour",   default: 0.0
    t.float    "purchase_escrow", default: 0.0
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "payments", ["client_id"], name: "index_payments_on_client_id", using: :btree

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
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.integer  "zoom_office_id"
    t.float    "addrlat"
    t.float    "addrlng"
    t.boolean  "active",                      default: false
  end

  add_index "providers", ["email"], name: "index_providers_on_email", using: :btree
  add_index "providers", ["reset_password_token"], name: "index_providers_on_reset_password_token", unique: true, using: :btree
  add_index "providers", ["uid", "provider"], name: "index_providers_on_uid_and_provider", unique: true, using: :btree
  add_index "providers", ["zoom_office_id"], name: "index_providers_on_zoom_office_id", using: :btree

  create_table "server_settings", force: :cascade do |t|
    t.float    "price_per_hour"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "settings", force: :cascade do |t|
    t.integer  "provider_id"
    t.date     "a1099"
    t.date     "noncompete"
    t.date     "confidentiality"
    t.date     "delivery"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.boolean  "sms",             default: true
    t.boolean  "email",           default: true
    t.boolean  "available",       default: true
  end

  add_index "settings", ["provider_id"], name: "index_settings_on_provider_id", using: :btree

  create_table "settings_types", id: false, force: :cascade do |t|
    t.integer "setting_id"
    t.integer "type_id"
  end

  add_index "settings_types", ["setting_id"], name: "index_settings_types_on_setting_id", using: :btree
  add_index "settings_types", ["type_id"], name: "index_settings_types_on_type_id", using: :btree

  create_table "task_uploads", force: :cascade do |t|
    t.integer  "task_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "upload_file_name"
    t.string   "upload_content_type"
    t.integer  "upload_file_size"
    t.datetime "upload_updated_at"
    t.string   "category"
  end

  add_index "task_uploads", ["task_id"], name: "index_task_uploads_on_task_id", using: :btree

  create_table "tasks", force: :cascade do |t|
    t.string   "title"
    t.datetime "datetime"
    t.string   "address"
    t.float    "addrlat"
    t.float    "addrlng"
    t.string   "contact"
    t.text     "details"
    t.boolean  "escrowable"
    t.integer  "client_id"
    t.integer  "provider_id"
    t.integer  "type_id"
    t.float    "usedHour",          default: 0.0
    t.float    "usedEscrow",        default: 0.0
    t.string   "status",            default: "open"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "zoom_office_id"
    t.string   "city"
    t.float    "funds",             default: 0.0
    t.string   "funds_details"
    t.string   "unit"
    t.integer  "frequency",         default: 0
    t.string   "pick_up_address"
    t.float    "pick_up_addrlat"
    t.float    "pick_up_addrlng"
    t.string   "pick_up_unit"
    t.string   "item"
    t.integer  "recurring_task_id"
  end

  add_index "tasks", ["client_id"], name: "index_tasks_on_client_id", using: :btree
  add_index "tasks", ["provider_id"], name: "index_tasks_on_provider_id", using: :btree
  add_index "tasks", ["type_id"], name: "index_tasks_on_type_id", using: :btree
  add_index "tasks", ["zoom_office_id"], name: "index_tasks_on_zoom_office_id", using: :btree

  create_table "types", force: :cascade do |t|
    t.string   "name"
    t.string   "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "zoom_offices", force: :cascade do |t|
    t.string   "longName"
    t.string   "shortName"
    t.float    "swLat"
    t.float    "swLng"
    t.float    "neLat"
    t.float    "neLng"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "admins", "zoom_offices"
  add_foreign_key "client_settings", "clients"
  add_foreign_key "clients", "zoom_offices"
  add_foreign_key "escrow_hours", "clients"
  add_foreign_key "notifications", "clients"
  add_foreign_key "payments", "clients"
  add_foreign_key "providers", "zoom_offices"
  add_foreign_key "settings", "providers"
  add_foreign_key "settings_types", "settings"
  add_foreign_key "settings_types", "types"
  add_foreign_key "task_uploads", "tasks"
  add_foreign_key "tasks", "clients"
  add_foreign_key "tasks", "providers"
  add_foreign_key "tasks", "types"
  add_foreign_key "tasks", "zoom_offices"
end
