class CreateShippingMethods < ActiveRecord::Migration
  def change
    create_table :shipping_methods do |t|
      t.belongs_to :shipping_zone,  null: false
      t.string  :name,              null: false
      t.decimal :lower_price_limit, precision: 8, scale: 2
      t.decimal :upper_price_limit, precision: 8, scale: 2
      t.decimal :base_price,        precision: 8, scale: 2
      t.decimal :offset,            precision: 8, scale: 2, default: 0
      t.boolean :active,            default: true
      t.integer :parent_id

      t.timestamps
    end
  end
end
