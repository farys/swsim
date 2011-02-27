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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110207085708) do

  create_table "alerts", :force => true do |t|
    t.integer  "author_id",  :null => false
    t.integer  "reader_id"
    t.integer  "model_id"
    t.string   "model_type"
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "auction_ratings", :id => false, :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "auction_id", :null => false
    t.float    "value",      :null => false
    t.datetime "created_at"
  end

  add_index "auction_ratings", ["user_id", "auction_id"], :name => "index_auction_ratings_on_user_id_and_auction_id", :unique => true

  create_table "auctions", :force => true do |t|
    t.boolean  "private",       :default => false, :null => false
    t.integer  "status",        :default => 0,     :null => false
    t.integer  "budget_id",                        :null => false
    t.integer  "owner_id",                         :null => false
    t.integer  "won_offer_id"
    t.string   "title",                            :null => false
    t.text     "description",                      :null => false
    t.datetime "expired",                          :null => false
    t.integer  "offers_count",  :default => 0
    t.integer  "visits",        :default => 0,     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ratings_sum",   :default => 0
    t.integer  "ratings_count", :default => 0
  end

  create_table "auctions_tags", :id => false, :force => true do |t|
    t.integer "tag_id"
    t.integer "auction_id"
  end

  add_index "auctions_tags", ["tag_id", "auction_id"], :name => "index_auctions_tags_on_tag_id_and_auction_id", :unique => true

  create_table "comment_keywords", :force => true do |t|
    t.integer  "destination", :null => false
    t.string   "name",        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comment_values", :force => true do |t|
    t.integer  "comment_id", :null => false
    t.integer  "keyword_id", :null => false
    t.string   "extra"
    t.integer  "status",     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.integer  "auction_id",                                                :null => false
    t.integer  "author_id",                                                 :null => false
    t.integer  "receiver_id",                                               :null => false
    t.integer  "team_id"
    t.decimal  "mark",        :precision => 10, :scale => 0
    t.integer  "status",                                     :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "communications", :force => true do |t|
    t.integer  "auction_id", :null => false
    t.text     "body",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", :force => true do |t|
    t.string "name", :null => false
  end

  create_table "groups_tags", :id => false, :force => true do |t|
    t.integer "tag_id"
    t.integer "group_id"
  end

  add_index "groups_tags", ["group_id", "tag_id"], :name => "index_groups_tags_on_group_id_and_tag_id", :unique => true

  create_table "messages", :force => true do |t|
    t.integer  "owner_id",                   :null => false
    t.integer  "author_id",                  :null => false
    t.integer  "receiver_id",                :null => false
    t.integer  "status",      :default => 2, :null => false
    t.text     "body"
    t.string   "topic",                      :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "offers", :force => true do |t|
    t.integer  "auction_id",                                :null => false
    t.integer  "offerer_id",                                :null => false
    t.integer  "status",                                    :null => false
    t.decimal  "price",      :precision => 10, :scale => 0, :null => false
    t.integer  "hours",                                     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "statistics", :force => true do |t|
    t.string   "name"
    t.text     "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "teams", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login",      :null => false
    t.string   "password",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
