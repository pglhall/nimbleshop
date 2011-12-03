class CreateShippingCountries < ActiveRecord::Migration

  def change
    create_table :shipping_countries do |t|
      t.integer :shipping_zone_id,        null: false
      t.integer :country_code,            null: false

      t.timestamps
    end
  end

end
