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

ActiveRecord::Schema.define(version: 2018_07_13_135604) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "dossiers_entreprises", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "code_greffe"
    t.string "nom_greffe"
    t.string "numero_gestion"
    t.string "siren"
    t.string "type_inscription"
    t.date "date_immatriculation"
    t.date "date_premiere_immatriculation"
    t.date "date_radiation"
    t.date "date_transfert"
    t.string "sans_activite"
    t.date "date_debut_activite"
    t.date "date_debut_premiere_activite"
    t.date "date_cessation_activite"
    t.date "date_derniere_modification"
    t.string "libelle_derniere_modification"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["numero_gestion"], name: "index_dossiers_entreprises_on_numero_gestion"
  end

end
