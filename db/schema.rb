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

ActiveRecord::Schema.define(:version => 20101221114231) do

  create_table "cartes", :force => true do |t|
    t.string   "nom"
    t.string   "info"
    t.integer  "village_id"
    t.string   "url_originale"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "actif",         :default => true
  end

  create_table "departements", :force => true do |t|
    t.integer  "region_id"
    t.string   "nom"
    t.string   "code"
    t.string   "nc"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "photos", :force => true do |t|
    t.integer  "village_id"
    t.string   "legende"
    t.string   "info"
    t.string   "url_originale"
    t.boolean  "actif",          :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "url_definitive"
  end

  create_table "regions", :force => true do |t|
    t.string   "nom"
    t.string   "code"
    t.string   "nc"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "villages", :force => true do |t|
    t.string   "article"
    t.string   "nom_sa"
    t.string   "nc"
    t.string   "longitude"
    t.string   "latitude"
    t.integer  "region_id"
    t.integer  "departement_id"
    t.string   "type_village"
    t.string   "rue"
    t.string   "cp"
    t.string   "ville"
    t.boolean  "actif",          :default => true
    t.datetime "date_entree"
    t.datetime "date_sortie"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
