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

ActiveRecord::Schema.define(version: 2024_05_14_223525) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attachments", force: :cascade do |t|
    t.bigint "rank_id", null: false
    t.bigint "attachment_id"
    t.text "attachment_filename"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["rank_id"], name: "index_attachments_on_rank_id"
  end

  create_table "emojis", force: :cascade do |t|
    t.bigint "rank_id", null: false
    t.string "emoji_name", null: false
    t.bigint "emoji_id"
    t.integer "count", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["rank_id"], name: "index_emojis_on_rank_id"
  end

  create_table "ranks", force: :cascade do |t|
    t.integer "order", default: 0, null: false
    t.bigint "channel_id", null: false
    t.string "channel_name", null: false
    t.bigint "thread_id"
    t.string "thread_name"
    t.bigint "message_id", null: false
    t.text "content", null: false
    t.bigint "author_id", null: false
    t.string "author_name", null: false
    t.string "author_avatar"
    t.string "author_discriminator", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "posted_at", null: false
    t.integer "total_emojis_count", null: false
    t.string "content_post"
    t.index ["order"], name: "index_ranks_on_order"
  end

  create_table "reactions", force: :cascade do |t|
    t.bigint "channel_id", null: false
    t.bigint "message_id", null: false
    t.bigint "user_id", null: false
    t.string "emoji_name", null: false
    t.bigint "emoji_id"
    t.datetime "reacted_at", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "point"
    t.index ["reacted_at"], name: "index_reactions_on_reacted_at"
  end

  create_table "users", force: :cascade do |t|
    t.string "provider", null: false
    t.string "uid", null: false
    t.string "name", null: false
    t.string "avatar"
    t.string "discriminator", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true
  end

  add_foreign_key "attachments", "ranks", on_update: :cascade, on_delete: :cascade
  add_foreign_key "emojis", "ranks", on_update: :cascade, on_delete: :cascade
end
