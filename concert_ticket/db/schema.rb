# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2025_08_16_140212) do
  create_table "active_storage_attachments", charset: "utf8mb3", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb3", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "channel_to_knows", charset: "utf8mb3", force: :cascade do |t|
    t.string "channel_name_th", limit: 200
    t.string "channel_name_en", limit: 200
    t.column "status", "enum('active','deleted')"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "concert_infos", charset: "utf8mb3", force: :cascade do |t|
    t.string "concert_name"
    t.datetime "event_day"
    t.integer "is_default", limit: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "projects", charset: "utf8mb3", force: :cascade do |t|
    t.string "project_name", limit: 200
    t.text "description"
    t.date "date"
    t.column "status", "enum('active','deleted')"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "qr_infos", charset: "utf8mb3", force: :cascade do |t|
    t.integer "numbers"
    t.string "location", limit: 250
    t.string "email", limit: 200
    t.text "qr_code"
    t.integer "ticket_used", default: 0
    t.column "status", "enum('active','inactive','deleted')", default: "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "event_id"
    t.string "auth_token"
    t.string "phone_number", limit: 100
    t.index ["auth_token"], name: "index_qr_infos_on_auth_token", unique: true
  end

  create_table "registered_users", charset: "utf8mb3", force: :cascade do |t|
    t.string "firstname", limit: 150
    t.string "lastname", limit: 150
    t.string "email", limit: 200
    t.string "phone_number", limit: 50
    t.date "dob"
    t.integer "gender", limit: 2
    t.string "country", limit: 150
    t.string "province", limit: 150
    t.string "district", limit: 150
    t.bigint "channel_to_know"
    t.bigint "default_language"
    t.bigint "qr_id"
    t.column "status", "enum('registered','participated','inactive')"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "workshop", limit: 2
    t.integer "concert", limit: 2
  end

  create_table "users", charset: "utf8mb3", force: :cascade do |t|
    t.string "username", limit: 250
    t.string "salt_password", limit: 250
    t.string "password", limit: 250
    t.string "firstname", limit: 250
    t.string "lastname", limit: 250
    t.column "status", "enum('active','inactive','deleted')", default: "active"
    t.integer "role", limit: 2
    t.string "email", limit: 250
    t.string "phone_number", limit: 20
    t.text "profile_pic"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
