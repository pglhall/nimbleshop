# This migration comes from nimbleshop_core (originally 20111202143154)
class CreateShippingZones < ActiveRecord::Migration

  def change
    create_table :shipping_zones do |t|
      t.string  :name
      t.string  :permalink,     null: false
      t.string  :country_code
      t.string  :state_code
      t.string  :type,          null: true
      t.integer :country_shipping_zone_id
      t.timestamps
    end

    add_index :shipping_zones, :permalink, unique: true
  end

end
