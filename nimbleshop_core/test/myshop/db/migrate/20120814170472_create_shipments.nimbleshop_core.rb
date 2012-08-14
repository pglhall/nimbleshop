# This migration comes from nimbleshop_core (originally 20120105234047)
class CreateShipments < ActiveRecord::Migration
  def change
    create_table :shipments do |t|
      t.string :tracking_number,         null: true
      t.belongs_to :shipment_carrier,    null: false
      t.belongs_to :order,               null: false

      t.timestamps
    end
  end
end
