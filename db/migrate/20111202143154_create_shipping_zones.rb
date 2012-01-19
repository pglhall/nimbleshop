class CreateShippingZones < ActiveRecord::Migration
  def change
    create_table :shipping_zones do |t|
      t.string  :name
      t.string  :permalink,     null: false
      t.string  :code
      t.string  :type,          null: false

      t.integer :country_shipping_zone_id
      t.timestamps
    end
    add_index :shipping_zones, :permalink, unique: true
  end
end
