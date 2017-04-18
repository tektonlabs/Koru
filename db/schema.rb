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

ActiveRecord::Schema.define(version: 20170410212408) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: :cascade do |t|
    t.string   "name",                       null: false
    t.boolean  "with_value", default: false, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "entities", force: :cascade do |t|
    t.string   "name",                   null: false
    t.integer  "parent_id"
    t.integer  "level",      default: 0, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "question_answers", force: :cascade do |t|
    t.integer  "question_id"
    t.integer  "answer_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["answer_id"], name: "index_question_answers_on_answer_id", using: :btree
    t.index ["question_id"], name: "index_question_answers_on_question_id", using: :btree
  end

  create_table "questionnaires", force: :cascade do |t|
    t.integer  "refuge_id"
    t.datetime "state_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["refuge_id"], name: "index_questionnaires_on_refuge_id", using: :btree
  end

  create_table "questions", force: :cascade do |t|
    t.integer  "entity_id"
    t.string   "text",                      null: false
    t.string   "min_text"
    t.string   "max_text"
    t.integer  "parent_id"
    t.integer  "question_type", default: 0, null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.index ["entity_id"], name: "index_questions_on_entity_id", using: :btree
  end

  create_table "refuge_entities", force: :cascade do |t|
    t.integer  "entity_id"
    t.integer  "refuge_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entity_id"], name: "index_refuge_entities_on_entity_id", using: :btree
    t.index ["refuge_id"], name: "index_refuge_entities_on_refuge_id", using: :btree
  end

  create_table "refuge_questions", force: :cascade do |t|
    t.integer  "refuge_id"
    t.integer  "entity_id"
    t.integer  "question_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["entity_id"], name: "index_refuge_questions_on_entity_id", using: :btree
    t.index ["question_id"], name: "index_refuge_questions_on_question_id", using: :btree
    t.index ["refuge_id"], name: "index_refuge_questions_on_refuge_id", using: :btree
  end

  create_table "refuges", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "lat"
    t.string   "long"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "responses", force: :cascade do |t|
    t.integer  "questionnaire_id",      null: false
    t.integer  "question_id",           null: false
    t.integer  "answer_selected_id",                 array: true
    t.string   "answer_responsed_text"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.index ["question_id"], name: "index_responses_on_question_id", using: :btree
    t.index ["questionnaire_id"], name: "index_responses_on_questionnaire_id", using: :btree
  end

  add_foreign_key "question_answers", "answers"
  add_foreign_key "question_answers", "questions"
  add_foreign_key "questionnaires", "refuges"
  add_foreign_key "questions", "entities"
  add_foreign_key "refuge_entities", "entities"
  add_foreign_key "refuge_entities", "refuges"
  add_foreign_key "refuge_questions", "entities"
  add_foreign_key "refuge_questions", "questions"
  add_foreign_key "refuge_questions", "refuges"
  add_foreign_key "responses", "questionnaires"
  add_foreign_key "responses", "questions"
end
