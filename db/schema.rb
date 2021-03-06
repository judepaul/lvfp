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

ActiveRecord::Schema.define(version: 20201218150458) do

  create_table "access_code_speech_maps", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "access_code_id"
    t.bigint "speech_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["access_code_id"], name: "index_access_code_speech_maps_on_access_code_id"
    t.index ["speech_id"], name: "index_access_code_speech_maps_on_speech_id"
  end

  create_table "access_codes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "code"
    t.string "title"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "listener_id"
    t.index ["listener_id"], name: "index_access_codes_on_listener_id"
    t.index ["user_id"], name: "index_access_codes_on_user_id"
  end

  create_table "audiances", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "voice_user_id"
    t.string "device_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
    t.string "phone"
  end

  create_table "contacts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text "name"
    t.text "email"
    t.text "phone"
    t.text "subject"
    t.text "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "devices", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "audiance_id"
    t.string "device_id"
    t.string "type"
    t.string "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["audiance_id"], name: "index_devices_on_audiance_id"
  end

  create_table "leads", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text "email"
    t.text "firstname"
    t.text "lastname"
    t.text "company"
    t.text "phone"
    t.text "address"
    t.text "city"
    t.text "state"
    t.text "country"
    t.text "zip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "listeners", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "user_id"
    t.string "group_name"
    t.string "group_code"
    t.string "group_title"
    t.string "group_description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_listeners_on_user_id"
  end

  create_table "speeches", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "email_code", default: 1000
    t.string "email_address"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_deleted"
    t.bigint "user_id"
    t.text "title"
    t.boolean "draft", default: false
    t.text "published_content"
    t.boolean "published", default: false
    t.text "email_from"
    t.datetime "email_sent_date"
    t.text "intro"
    t.text "outro"
    t.text "name"
    t.text "sub_title_text"
    t.text "intro_jingle"
    t.text "title_jingle"
    t.text "sub_title_jingle"
    t.text "outro_jingle"
    t.index ["user_id"], name: "index_speeches_on_user_id"
  end

  create_table "subscriptions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "audiance_id"
    t.bigint "access_code_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_subscribed"
    t.index ["access_code_id"], name: "index_subscriptions_on_access_code_id"
    t.index ["audiance_id"], name: "index_subscriptions_on_audiance_id"
  end

  create_table "user_content_maps", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "user_id"
    t.bigint "speech_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["speech_id"], name: "index_user_content_maps_on_speech_id"
    t.index ["user_id"], name: "index_user_content_maps_on_user_id"
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "device_id"
    t.integer "access_code"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.bigint "lead_id"
    t.text "firstname"
    t.text "lastname"
    t.index ["lead_id"], name: "index_users_on_lead_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "access_code_speech_maps", "access_codes"
  add_foreign_key "access_code_speech_maps", "speeches"
  add_foreign_key "access_codes", "listeners"
  add_foreign_key "access_codes", "users"
  add_foreign_key "devices", "audiances"
  add_foreign_key "listeners", "users"
  add_foreign_key "speeches", "users"
  add_foreign_key "subscriptions", "access_codes"
  add_foreign_key "subscriptions", "audiances"
  add_foreign_key "user_content_maps", "speeches"
  add_foreign_key "user_content_maps", "users"
  add_foreign_key "users", "leads"
end
