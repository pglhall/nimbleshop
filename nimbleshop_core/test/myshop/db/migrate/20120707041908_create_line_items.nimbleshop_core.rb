# This migration comes from nimbleshop_core (originally 20111022144725)
class CreateLineItems < ActiveRecord::Migration
  def change
    create_table :line_items do |t|
      t.belongs_to :order,              null: false
      t.belongs_to :product,            null: false
      t.integer    :quantity,           null: false
      t.string     :product_name,       null: false
      t.text       :product_description
      t.decimal    :product_price,      null: false, precision: 8, scale: 2
      t.text       :metadata

      t.timestamps
    end
  end
end
