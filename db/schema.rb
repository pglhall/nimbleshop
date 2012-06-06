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

ActiveRecord::Schema.define(:version => 20120606165355) do

  create_table "addresses", :force => true do |t|
    t.string   "type"
    t.integer  "order_id"
    t.string   "first_name",                        :null => false
    t.string   "last_name"
    t.string   "company"
    t.string   "address1",                          :null => false
    t.string   "address2"
    t.string   "city",                              :null => false
    t.string   "zipcode"
    t.string   "country_name",                      :null => false
    t.string   "country_code",                      :null => false
    t.string   "state_name",                        :null => false
    t.string   "state_code"
    t.string   "phone"
    t.string   "fax"
    t.boolean  "use_for_billing", :default => true, :null => false
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  create_table "custom_field_answers", :force => true do |t|
    t.integer  "product_id"
    t.integer  "custom_field_id"
    t.string   "value"
    t.string   "text_value"
    t.integer  "number_value"
    t.datetime "datetime_value"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "custom_fields", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "field_type", :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "line_items", :force => true do |t|
    t.integer  "order_id",                                          :null => false
    t.integer  "product_id",                                        :null => false
    t.integer  "quantity",                                          :null => false
    t.string   "product_name",                                      :null => false
    t.text     "product_description"
    t.decimal  "product_price",       :precision => 8, :scale => 2, :null => false
    t.text     "metadata"
    t.datetime "created_at",                                        :null => false
    t.datetime "updated_at",                                        :null => false
  end

  create_table "link_groups", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "permalink",  :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "link_groups", ["name"], :name => "index_link_groups_on_name", :unique => true
  add_index "link_groups", ["permalink"], :name => "index_link_groups_on_permalink", :unique => true

  create_table "links", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "url",        :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "navigations", :force => true do |t|
    t.integer  "link_group_id",    :null => false
    t.integer  "product_group_id", :null => false
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "orders", :force => true do |t|
    t.string   "number",                                                :null => false
    t.integer  "shipping_method_id"
    t.integer  "payment_method_id"
    t.string   "email"
    t.string   "status",             :default => "open",                :null => false
    t.string   "payment_status",     :default => "abandoned_early",     :null => false
    t.string   "shipping_status",    :default => "nothing_to_ship",     :null => false
    t.string   "checkout_status",    :default => "items_added_to_cart", :null => false
    t.datetime "shipped_at"
    t.datetime "paid_at"
    t.text     "metadata"
    t.datetime "created_at",                                            :null => false
    t.datetime "updated_at",                                            :null => false
  end

  add_index "orders", ["number"], :name => "index_orders_on_number", :unique => true

  create_table "payment_methods", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "type"
    t.string   "permalink",   :null => false
    t.text     "metadata"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "payment_methods", ["permalink"], :name => "index_payment_methods_on_permalink", :unique => true

  create_table "payment_transactions", :force => true do |t|
    t.integer  "order_id",        :null => false
    t.string   "transaction_gid", :null => false
    t.text     "params",          :null => false
    t.boolean  "success",         :null => false
    t.string   "operation",       :null => false
    t.integer  "amount"
    t.text     "metadata"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "paypal_payment_notifications", :force => true do |t|
    t.text     "raw_post"
    t.string   "order_id",   :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "paypal_payment_notifications", ["order_id"], :name => "index_paypal_payment_notifications_on_order_id", :unique => true

  create_table "pictures", :force => true do |t|
    t.integer  "product_id"
    t.string   "picture"
    t.string   "file_name"
    t.string   "content_type"
    t.string   "file_size"
    t.integer  "position",                   :default => 0
    t.string   "picture_width"
    t.string   "picture_height"
    t.string   "picture_tiny_width"
    t.string   "picture_tiny_height"
    t.string   "picture_tiny_plus_width"
    t.string   "picture_tiny_plus_height"
    t.string   "picture_small_width"
    t.string   "picture_small_height"
    t.string   "picture_small_plus_width"
    t.string   "picture_small_plus_height"
    t.string   "picture_medium_width"
    t.string   "picture_medium_height"
    t.string   "picture_medium_plus_width"
    t.string   "picture_medium_plus_height"
    t.string   "picture_large_width"
    t.string   "picture_large_height"
    t.string   "picture_large_plus_width"
    t.string   "picture_large_plus_height"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
  end

  create_table "preferences", :force => true do |t|
    t.string   "name",       :null => false
    t.integer  "owner_id",   :null => false
    t.string   "owner_type", :null => false
    t.integer  "group_id"
    t.string   "group_type"
    t.string   "value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "preferences", ["owner_id", "owner_type", "name", "group_id", "group_type"], :name => "index_preferences_on_owner_and_name_and_preference", :unique => true

  create_table "product_group_conditions", :force => true do |t|
    t.integer  "product_group_id"
    t.string   "name",             :null => false
    t.string   "operator",         :null => false
    t.string   "value"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "product_groups", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "permalink",  :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "product_groups", ["name"], :name => "index_product_groups_on_name", :unique => true
  add_index "product_groups", ["permalink"], :name => "index_product_groups_on_permalink", :unique => true

  create_table "products", :force => true do |t|
    t.string   "name",                                                            :null => false
    t.string   "status",                                    :default => "active", :null => false
    t.text     "description"
    t.decimal  "price",       :precision => 8, :scale => 2,                       :null => false
    t.boolean  "new",                                       :default => false,    :null => false
    t.string   "permalink",                                                       :null => false
    t.datetime "created_at",                                                      :null => false
    t.datetime "updated_at",                                                      :null => false
  end

  add_index "products", ["permalink"], :name => "index_products_on_permalink", :unique => true

  create_table "shipment_carriers", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "permalink",  :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "shipment_carriers", ["permalink"], :name => "index_shipment_carriers_on_permalink", :unique => true

  create_table "shipments", :force => true do |t|
    t.string   "tracking_number"
    t.integer  "shipment_carrier_id", :null => false
    t.integer  "order_id",            :null => false
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "shipping_methods", :force => true do |t|
    t.integer  "shipping_zone_id",                                                  :null => false
    t.string   "name",                                                              :null => false
    t.decimal  "lower_price_limit", :precision => 8, :scale => 2
    t.decimal  "upper_price_limit", :precision => 8, :scale => 2
    t.decimal  "base_price",        :precision => 8, :scale => 2
    t.decimal  "offset",            :precision => 8, :scale => 2, :default => 0.0
    t.boolean  "active",                                          :default => true
    t.integer  "parent_id"
    t.datetime "created_at",                                                        :null => false
    t.datetime "updated_at",                                                        :null => false
  end

  create_table "shipping_zones", :force => true do |t|
    t.string   "name"
    t.string   "permalink",                :null => false
    t.string   "country_code"
    t.string   "state_code"
    t.string   "type"
    t.integer  "country_shipping_zone_id"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "shipping_zones", ["permalink"], :name => "index_shipping_zones_on_permalink", :unique => true

  create_table "shops", :force => true do |t|
    t.string   "name",                                                                                :null => false
    t.string   "author_name"
    t.string   "description"
    t.string   "theme",                                                      :default => "simply",    :null => false
    t.string   "time_zone",                                                  :default => "UTC",       :null => false
    t.string   "from_email",                                                                          :null => false
    t.string   "default_creditcard_action",                                  :default => "authorize", :null => false
    t.string   "phone_number"
    t.string   "twitter_handle"
    t.string   "facebook_url"
    t.string   "google_analytics_tracking_id"
    t.decimal  "tax_percentage",               :precision => 4, :scale => 2, :default => 0.0,         :null => false
    t.datetime "created_at",                                                                          :null => false
    t.datetime "updated_at",                                                                          :null => false
  end

end
