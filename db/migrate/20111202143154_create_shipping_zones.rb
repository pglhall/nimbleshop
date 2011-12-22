class CreateShippingZones < ActiveRecord::Migration

  def change
    create_table :shipping_zones do |t|
      t.string  :name,              null: false
      t.string  :permalink,         null: false
      t.boolean :active,            default: true

      t.timestamps
    end
  end

end
