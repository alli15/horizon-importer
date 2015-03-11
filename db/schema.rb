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

ActiveRecord::Schema.define(version: 20150310224849) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "history_ledgers", force: true do |t|
    t.integer  "sequence",                                    null: false
    t.string   "ledger_hash",          limit: 64,             null: false
    t.string   "previous_ledger_hash", limit: 64
    t.integer  "transaction_count",               default: 0, null: false
    t.integer  "operation_count",                 default: 0, null: false
    t.datetime "closed_at",                                   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "history_ledgers", ["closed_at"], name: "index_history_ledgers_on_closed_at", using: :btree
  add_index "history_ledgers", ["ledger_hash"], name: "index_history_ledgers_on_ledger_hash", unique: true, using: :btree
  add_index "history_ledgers", ["previous_ledger_hash"], name: "index_history_ledgers_on_previous_ledger_hash", unique: true, using: :btree
  add_index "history_ledgers", ["sequence"], name: "index_history_ledgers_on_sequence", unique: true, using: :btree

  create_table "pending_transactions", force: true do |t|
    t.integer  "state",                          default: 0, null: false
    t.string   "sending_address",     limit: 64,             null: false
    t.integer  "sending_sequence",                           null: false
    t.integer  "max_ledger_sequence", limit: 8
    t.integer  "min_ledger_sequence", limit: 8
    t.text     "tx_envelope",                                null: false
    t.string   "tx_hash",             limit: 64,             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pending_transactions", ["sending_address", "sending_sequence"], name: "by_sequence", using: :btree
  add_index "pending_transactions", ["state"], name: "index_pending_transactions_on_state", using: :btree

end
