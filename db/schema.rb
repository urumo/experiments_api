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

ActiveRecord::Schema[7.1].define(version: 2023_12_28_030353) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "device_experiments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "device_id", null: false
    t.uuid "experiment_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["device_id"], name: "index_device_experiments_on_device_id"
    t.index ["experiment_id"], name: "index_device_experiments_on_experiment_id"
  end

  create_table "devices", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_devices_on_user_id"
  end

  create_table "experiments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "key"
    t.string "value"
    t.float "chance"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "completed", default: false, null: false
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest"
    t.integer "role", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "device_experiments", "devices"
  add_foreign_key "device_experiments", "experiments"
  add_foreign_key "devices", "users"

  create_view "distributions", sql_definition: <<-SQL
      SELECT e.id,
      e.key,
      e.value,
      count(e.value) AS amount,
      total_devices.count AS total_devices,
      round((((count(e.value))::numeric * 100.0) / (total_devices.count)::numeric), 3) AS percent_of_total,
      key_devices.count AS key_devices,
      round((((count(e.value))::numeric * 100.0) / (key_devices.count)::numeric), 3) AS percent_of_key,
      e.chance,
      now() AS created_at
     FROM ((devices d
       LEFT JOIN device_experiments de ON ((d.id = de.device_id)))
       LEFT JOIN experiments e ON ((de.experiment_id = e.id))),
      ( SELECT count(*) AS count
             FROM devices) total_devices,
      ( SELECT e_1.key,
              count(*) AS count
             FROM ((devices d_1
               LEFT JOIN device_experiments de_1 ON ((d_1.id = de_1.device_id)))
               LEFT JOIN experiments e_1 ON ((de_1.experiment_id = e_1.id)))
            WHERE (e_1.key IS NOT NULL)
            GROUP BY e_1.key) key_devices
    WHERE ((e.key IS NOT NULL) AND ((e.key)::text = (key_devices.key)::text))
    GROUP BY e.key, e.value, e.chance, total_devices.count, key_devices.count, e.id
    ORDER BY e.chance DESC;
  SQL
end
