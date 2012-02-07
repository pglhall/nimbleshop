class CreateShippingZones < ActiveRecord::Migration
  def change
    create_table :shipping_zones do |t|
      t.string  :name
      t.string  :permalink,     null: false
      t.string  :country_code
      t.string  :state_code

      # TODO it should be not nullable. It is a hack being added
      # by Neeraj because migration to rails 3.2 is failing
      t.string  :type,          null: true

      t.integer :country_shipping_zone_id
      t.timestamps
    end
    add_index :shipping_zones, :permalink, unique: true
  end
end
