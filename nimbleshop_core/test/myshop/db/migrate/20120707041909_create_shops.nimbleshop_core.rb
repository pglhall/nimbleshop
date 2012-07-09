# This migration comes from nimbleshop_core (originally 20111022234951)
class CreateShops < ActiveRecord::Migration
  def change
    create_table :shops do |t|
      t.string :name,                         null: false
      t.string :author_name,                  null: true
      t.string :description,                  null: true
      t.string :theme,                        null: false, default: 'simply'
      t.string :time_zone,                    null: false, default: 'UTC'
      t.string :from_email,                   null: false
      t.string :default_creditcard_action,    null: false, default: 'authorize'
      t.string :phone_number
      t.string :twitter_handle
      t.string :facebook_url
      t.string :google_analytics_tracking_id
      t.decimal :tax_percentage, precision: 4, scale: 2, null: false, default: 0

      t.timestamps
    end
  end
end
