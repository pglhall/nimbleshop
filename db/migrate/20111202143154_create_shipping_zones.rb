class CreateShippingZones < ActiveRecord::Migration

  def change
    create_table :shipping_zones do |t|
      t.string  :name,              null: false

      t.timestamps
    end
  end

end
