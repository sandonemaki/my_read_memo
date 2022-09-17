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

ActiveRecord::Schema.define(version: 2022_09_17_115137) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "books", force: :cascade do |t|
    t.string "title", limit: 60, default: "", null: false
    t.string "author_1", limit: 60, default: "", null: false
    t.string "author_2", limit: 60, default: ""
    t.string "publisher", limit: 60, default: ""
    t.integer "total_page", null: false
    t.integer "reading_state", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "randoku_imgs", force: :cascade do |t|
    t.integer "first_post_flag", default: 0, null: false
    t.integer "looked_flag", default: 0, null: false
    t.string "path", null: false
    t.string "name", null: false
    t.integer "reading_state", default: 0, null: false
    t.bigint "book_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["book_id"], name: "index_randoku_imgs_on_book_id"
  end

  add_foreign_key "randoku_imgs", "books"
end
