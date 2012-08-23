# This migration comes from nimbleshop_core (originally 20120105234553)
class CreateShipmentCarriers < ActiveRecord::Migration
  def change
    create_table :shipment_carriers do |t|
      t.string :name,      null: false
      t.string :permalink, null: false

      t.timestamps
    end
    add_index :shipment_carriers, :permalink, unique: true
  end
end
