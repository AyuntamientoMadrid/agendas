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

ActiveRecord::Schema.define(version: 20180326083120) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "key"
    t.text     "parameters"
    t.integer  "recipient_id"
    t.string   "recipient_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
  end

  add_index "activities", ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type", using: :btree
  add_index "activities", ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type", using: :btree
  add_index "activities", ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type", using: :btree

  create_table "agents", force: :cascade do |t|
    t.string   "identifier"
    t.string   "name"
    t.string   "first_surname"
    t.string   "second_surname"
    t.date     "from"
    t.date     "to"
    t.text     "public_assignments"
    t.integer  "organization_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.boolean  "allow_public_data"
  end

  add_index "agents", ["organization_id"], name: "index_agents_on_organization_id", using: :btree

  create_table "areas", force: :cascade do |t|
    t.integer  "internal_id"
    t.string   "title"
    t.integer  "active"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "ancestry"
    t.string   "internal_code"
  end

  add_index "areas", ["ancestry"], name: "index_areas_on_ancestry", using: :btree

  create_table "attachments", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.integer  "event_id"
    t.text     "description"
    t.boolean  "public"
    t.integer  "agent_id"
    t.integer  "organization_id"
  end

  add_index "attachments", ["agent_id"], name: "index_attachments_on_agent_id", using: :btree
  add_index "attachments", ["event_id"], name: "index_attachments_on_event_id", using: :btree
  add_index "attachments", ["organization_id"], name: "index_attachments_on_organization_id", using: :btree

  create_table "attendees", force: :cascade do |t|
    t.string   "name"
    t.string   "position"
    t.string   "company"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "event_id"
  end

  add_index "attendees", ["event_id"], name: "index_attendees_on_event_id", using: :btree

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean  "display"
  end

  create_table "event_agents", force: :cascade do |t|
    t.integer "event_id"
    t.string  "name"
  end

  add_index "event_agents", ["event_id"], name: "index_event_agents_on_event_id", using: :btree

  create_table "event_represented_entities", force: :cascade do |t|
    t.integer "event_id"
    t.string  "name"
  end

  add_index "event_represented_entities", ["event_id"], name: "index_event_represented_entities_on_event_id", using: :btree

  create_table "events", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "scheduled"
    t.integer  "user_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "position_id"
    t.string   "location"
    t.string   "slug"
    t.integer  "status",                  default: 0
    t.boolean  "lobby_activity"
    t.text     "notes"
    t.string   "canceled_reasons"
    t.date     "published_at"
    t.date     "canceled_at"
    t.string   "organization_name"
    t.text     "lobby_scheduled"
    t.text     "general_remarks"
    t.string   "lobby_contact_firstname"
    t.string   "lobby_contact_lastname"
    t.string   "lobby_contact_email"
    t.string   "lobby_contact_phone"
    t.text     "manager_general_remarks"
    t.integer  "organization_id"
    t.date     "declined_at"
    t.string   "declined_reasons"
    t.date     "accepted_at"
  end

  add_index "events", ["position_id"], name: "index_events_on_position_id", using: :btree
  add_index "events", ["slug"], name: "index_events_on_slug", unique: true, using: :btree
  add_index "events", ["user_id"], name: "index_events_on_user_id", using: :btree

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

  create_table "holders", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "user_key"
  end

  create_table "interests", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "legal_representants", force: :cascade do |t|
    t.string   "identifier"
    t.string   "name"
    t.string   "first_surname"
    t.string   "second_surname"
    t.string   "phones"
    t.string   "email"
    t.integer  "organization_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.boolean  "check_email"
    t.boolean  "check_sms"
  end

  add_index "legal_representants", ["organization_id"], name: "index_legal_representants_on_organization_id", using: :btree

  create_table "manages", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "holder_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "manages", ["holder_id"], name: "index_manages_on_holder_id", using: :btree
  add_index "manages", ["user_id"], name: "index_manages_on_user_id", using: :btree

  create_table "organization_interests", force: :cascade do |t|
    t.integer  "organization_id"
    t.integer  "interest_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "organization_interests", ["interest_id"], name: "index_organization_interests_on_interest_id", using: :btree
  add_index "organization_interests", ["organization_id"], name: "index_organization_interests_on_organization_id", using: :btree

  create_table "organization_registered_lobbies", force: :cascade do |t|
    t.integer  "organization_id"
    t.integer  "registered_lobby_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "organization_registered_lobbies", ["organization_id"], name: "index_organization_registered_lobbies_on_organization_id", using: :btree
  add_index "organization_registered_lobbies", ["registered_lobby_id"], name: "index_organization_registered_lobbies_on_registered_lobby_id", using: :btree

  create_table "organizations", force: :cascade do |t|
    t.string   "reference"
    t.string   "identifier"
    t.string   "name"
    t.string   "first_surname"
    t.string   "second_surname"
    t.string   "address_type"
    t.string   "address"
    t.string   "number"
    t.string   "gateway"
    t.string   "stairs"
    t.string   "floor"
    t.string   "door"
    t.string   "postal_code"
    t.string   "town"
    t.string   "province"
    t.string   "phones"
    t.string   "email"
    t.integer  "category_id"
    t.string   "description",            default: ""
    t.string   "web"
    t.integer  "registered_lobbies"
    t.integer  "fiscal_year"
    t.integer  "range_fund"
    t.boolean  "subvention",             default: false
    t.boolean  "contract",               default: false
    t.boolean  "certain_term"
    t.boolean  "code_of_conduct_term"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "inscription_reference"
    t.datetime "inscription_date"
    t.integer  "entity_type"
    t.string   "neighbourhood"
    t.string   "district"
    t.string   "scope"
    t.integer  "associations_count"
    t.integer  "members_count"
    t.string   "approach"
    t.datetime "invalidated_at"
    t.datetime "canceled_at"
    t.string   "invalidated_reasons"
    t.string   "country"
    t.date     "modification_date"
    t.boolean  "gift_term"
    t.boolean  "lobby_term"
    t.string   "address_number_type"
    t.date     "termination_date"
    t.boolean  "own_lobby_activity",     default: false
    t.boolean  "foreign_lobby_activity", default: false
    t.string   "number_type"
    t.boolean  "check_email"
    t.boolean  "check_sms"
    t.string   "other_registered_lobby"
  end

  add_index "organizations", ["category_id"], name: "index_organizations_on_category_id", using: :btree

  create_table "participants", force: :cascade do |t|
    t.integer  "position_id"
    t.integer  "event_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "participants", ["event_id"], name: "index_participants_on_event_id", using: :btree
  add_index "participants", ["position_id"], name: "index_participants_on_position_id", using: :btree

  create_table "positions", force: :cascade do |t|
    t.string   "title"
    t.datetime "to"
    t.integer  "area_id"
    t.integer  "holder_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "positions", ["area_id"], name: "index_positions_on_area_id", using: :btree
  add_index "positions", ["holder_id"], name: "index_positions_on_holder_id", using: :btree

  create_table "questions", force: :cascade do |t|
    t.string   "title"
    t.text     "answer"
    t.integer  "position",   default: 1
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "registered_lobbies", force: :cascade do |t|
    t.text     "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "represented_entities", force: :cascade do |t|
    t.string   "identifier"
    t.string   "name"
    t.string   "first_surname"
    t.string   "second_surname"
    t.date     "from"
    t.date     "to"
    t.integer  "organization_id"
    t.integer  "fiscal_year"
    t.integer  "range_fund"
    t.boolean  "subvention",      default: false
    t.boolean  "contract",        default: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "represented_entities", ["organization_id"], name: "index_represented_entities_on_organization_id", using: :btree

  create_table "users", force: :cascade do |t|
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
    t.integer  "role"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "active"
    t.string   "user_key"
    t.string   "phones"
    t.integer  "organization_id"
    t.datetime "deleted_at"
    t.string   "identifier"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["organization_id"], name: "index_users_on_organization_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "agents", "organizations"
  add_foreign_key "attachments", "events"
  add_foreign_key "attachments", "organizations"
  add_foreign_key "attendees", "events"
  add_foreign_key "event_agents", "events"
  add_foreign_key "event_represented_entities", "events"
  add_foreign_key "events", "positions"
  add_foreign_key "events", "users"
  add_foreign_key "legal_representants", "organizations"
  add_foreign_key "manages", "holders"
  add_foreign_key "manages", "users"
  add_foreign_key "organization_interests", "interests"
  add_foreign_key "organization_interests", "organizations"
  add_foreign_key "organization_registered_lobbies", "organizations"
  add_foreign_key "organization_registered_lobbies", "registered_lobbies"
  add_foreign_key "organizations", "categories"
  add_foreign_key "participants", "events"
  add_foreign_key "participants", "positions"
  add_foreign_key "positions", "areas"
  add_foreign_key "positions", "holders"
  add_foreign_key "represented_entities", "organizations"
  add_foreign_key "users", "organizations"
end
