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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121116043408) do

  create_table "addresses", :force => true do |t|
    t.string   "street"
    t.string   "house"
    t.integer  "organization_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "latitude"
    t.string   "longitude"
  end

  add_index "addresses", ["organization_id"], :name => "index_addresses_on_organization_id"

  create_table "affiche_schedules", :force => true do |t|
    t.integer  "affiche_id"
    t.date     "starts_on"
    t.date     "ends_on"
    t.time     "starts_at"
    t.time     "ends_at"
    t.string   "holidays"
    t.string   "place"
    t.string   "hall"
    t.integer  "price_min"
    t.integer  "price_max"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "organization_id"
    t.string   "latitude"
    t.string   "longitude"
  end

  add_index "affiche_schedules", ["affiche_id"], :name => "index_affiche_schedules_on_affiche_id"

  create_table "affiches", :force => true do |t|
    t.string   "title"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.text     "description"
    t.string   "original_title"
    t.string   "poster_url"
    t.text     "trailer_code"
    t.string   "type"
    t.text     "tag"
    t.string   "vfs_path"
    t.string   "image_url"
    t.datetime "distribution_starts_on"
    t.datetime "distribution_ends_on"
    t.string   "slug"
    t.boolean  "constant"
    t.integer  "yandex_metrika_page_views"
    t.integer  "vkontakte_likes"
    t.string   "vk_aid"
    t.string   "yandex_fotki_url"
    t.float    "popularity"
  end

  add_index "affiches", ["slug"], :name => "index_affiches_on_slug", :unique => true

  create_table "attachments", :force => true do |t|
    t.integer  "attachable_id"
    t.string   "attachable_type"
    t.string   "url"
    t.text     "description"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "cultures", :force => true do |t|
    t.text     "category"
    t.text     "feature"
    t.text     "offer"
    t.string   "payment"
    t.integer  "organization_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "title"
    t.text     "description"
  end

  create_table "entertainments", :force => true do |t|
    t.text     "category"
    t.text     "feature"
    t.text     "offer"
    t.string   "payment"
    t.integer  "organization_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "title"
    t.text     "description"
  end

  add_index "entertainments", ["organization_id"], :name => "index_entertainments_on_organization_id"

  create_table "halls", :force => true do |t|
    t.string   "title"
    t.integer  "seating_capacity"
    t.integer  "organization_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "halls", ["organization_id"], :name => "index_halls_on_organization_id"

  create_table "images", :force => true do |t|
    t.text     "url"
    t.integer  "imageable_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.text     "description"
    t.string   "imageable_type"
    t.string   "thumbnail_url"
    t.integer  "width"
    t.integer  "height"
  end

  add_index "images", ["imageable_id"], :name => "index_images_on_organization_id"

  create_table "meals", :force => true do |t|
    t.text     "category"
    t.text     "feature"
    t.text     "offer"
    t.string   "payment"
    t.text     "cuisine"
    t.integer  "organization_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "title"
    t.text     "description"
  end

  add_index "meals", ["organization_id"], :name => "index_meals_on_organization_id"

  create_table "organization_stands", :force => true do |t|
    t.integer  "organization_id"
    t.integer  "places"
    t.boolean  "guarded"
    t.boolean  "video_observation"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "organization_stands", ["organization_id"], :name => "index_organization_stands_on_organization_id"

  create_table "organizations", :force => true do |t|
    t.text     "title"
    t.text     "site"
    t.text     "email"
    t.text     "description"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.text     "phone"
    t.string   "vfs_path"
    t.integer  "organization_id"
    t.text     "logotype_url"
    t.string   "slug"
    t.text     "tour_link"
    t.float    "rating"
    t.boolean  "non_cash"
    t.string   "priority_suborganization_kind"
  end

  add_index "organizations", ["slug"], :name => "index_organizations_on_slug", :unique => true

  create_table "sauna_accessories", :force => true do |t|
    t.integer  "sauna_id"
    t.integer  "sheets"
    t.integer  "sneakers"
    t.integer  "bathrobes"
    t.integer  "towels"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.boolean  "ware"
    t.string   "title"
    t.text     "description"
  end

  add_index "sauna_accessories", ["sauna_id"], :name => "index_sauna_accessories_on_sauna_id"

  create_table "sauna_alcohols", :force => true do |t|
    t.integer  "sauna_id"
    t.integer  "ability_own"
    t.boolean  "sale"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "sauna_alcohols", ["sauna_id"], :name => "index_sauna_alcohols_on_sauna_id"

  create_table "sauna_brooms", :force => true do |t|
    t.integer  "sauna_id"
    t.integer  "ability"
    t.integer  "sale"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sauna_brooms", ["sauna_id"], :name => "index_sauna_brooms_on_sauna_id"

  create_table "sauna_child_stuffs", :force => true do |t|
    t.integer  "sauna_id"
    t.integer  "life_jacket"
    t.integer  "cartoons"
    t.integer  "games"
    t.integer  "rubber_ring"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "sauna_child_stuffs", ["sauna_id"], :name => "index_sauna_child_stuffs_on_sauna_id"

  create_table "sauna_hall_baths", :force => true do |t|
    t.integer  "sauna_hall_id"
    t.boolean  "russian"
    t.boolean  "finnish"
    t.boolean  "turkish"
    t.boolean  "japanese"
    t.boolean  "infrared"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "sauna_hall_baths", ["sauna_hall_id"], :name => "index_sauna_hall_baths_on_sauna_hall_id"

  create_table "sauna_hall_capacities", :force => true do |t|
    t.integer  "sauna_hall_id"
    t.integer  "default"
    t.integer  "maximal"
    t.integer  "extra_guest_cost"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "sauna_hall_entertainments", :force => true do |t|
    t.integer  "sauna_hall_id"
    t.integer  "karaoke"
    t.integer  "tv"
    t.integer  "billiard"
    t.integer  "ping_pong"
    t.integer  "hookah"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "aerohockey"
    t.integer  "checkers"
    t.integer  "chess"
    t.integer  "backgammon"
    t.integer  "guitar"
  end

  add_index "sauna_hall_entertainments", ["sauna_hall_id"], :name => "index_sauna_hall_entertainments_on_sauna_hall_id"

  create_table "sauna_hall_interiors", :force => true do |t|
    t.integer  "sauna_hall_id"
    t.integer  "floors"
    t.integer  "lounges"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.boolean  "pit"
    t.boolean  "pylon"
    t.boolean  "barbecue"
  end

  add_index "sauna_hall_interiors", ["sauna_hall_id"], :name => "index_sauna_hall_interiors_on_sauna_hall_id"

  create_table "sauna_hall_pools", :force => true do |t|
    t.integer  "sauna_hall_id"
    t.string   "size"
    t.boolean  "contraflow"
    t.boolean  "geyser"
    t.boolean  "waterfall"
    t.string   "water_filter"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "jacuzzi"
    t.integer  "bucket"
  end

  add_index "sauna_hall_pools", ["sauna_hall_id"], :name => "index_sauna_hall_pools_on_sauna_hall_id"

  create_table "sauna_hall_schedules", :force => true do |t|
    t.integer  "sauna_hall_id"
    t.integer  "day"
    t.time     "from"
    t.time     "to"
    t.integer  "price"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "sauna_hall_schedules", ["sauna_hall_id"], :name => "index_sauna_hall_schedules_on_sauna_hall_id"

  create_table "sauna_halls", :force => true do |t|
    t.integer  "sauna_id"
    t.string   "title"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "tour_link"
    t.text     "vfs_path"
    t.text     "description"
  end

  add_index "sauna_halls", ["sauna_id"], :name => "index_sauna_halls_on_sauna_id"

  create_table "sauna_massages", :force => true do |t|
    t.integer  "sauna_id"
    t.integer  "classical"
    t.integer  "spa"
    t.integer  "anticelltilitis"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "sauna_massages", ["sauna_id"], :name => "index_sauna_massages_on_sauna_id"

  create_table "sauna_oils", :force => true do |t|
    t.integer  "sauna_id"
    t.integer  "ability"
    t.boolean  "sale"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sauna_oils", ["sauna_id"], :name => "index_sauna_oils_on_sauna_id"

  create_table "sauna_stuffs", :force => true do |t|
    t.integer  "sauna_id"
    t.integer  "wifi"
    t.integer  "safe"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sauna_stuffs", ["sauna_id"], :name => "index_sauna_stuffs_on_sauna_id"

  create_table "saunas", :force => true do |t|
    t.integer  "organization_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "saunas", ["organization_id"], :name => "index_saunas_on_organization_id"

  create_table "schedules", :force => true do |t|
    t.integer  "day"
    t.time     "from"
    t.time     "to"
    t.integer  "organization_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.boolean  "holiday"
  end

  create_table "services", :force => true do |t|
    t.text     "title"
    t.text     "feature"
    t.text     "age"
    t.text     "tag"
    t.string   "context_type"
    t.integer  "context_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.text     "offer"
  end

  create_table "showings", :force => true do |t|
    t.integer  "affiche_id"
    t.string   "place"
    t.datetime "starts_at"
    t.integer  "price_min"
    t.string   "hall"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.datetime "ends_at"
    t.integer  "price_max"
    t.integer  "organization_id"
    t.string   "latitude"
    t.string   "longitude"
  end

  add_index "showings", ["affiche_id"], :name => "index_showings_on_affiche_id"

  create_table "sports", :force => true do |t|
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "organization_id"
    t.string   "title"
    t.text     "description"
  end

end
