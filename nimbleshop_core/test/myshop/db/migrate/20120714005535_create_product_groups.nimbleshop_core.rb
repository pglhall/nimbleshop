# This migration comes from nimbleshop_core (originally 20111022144421)
class CreateProductGroups < ActiveRecord::Migration
  def change
    create_table :product_groups do |t|
      t.string :name,      null: false
      t.string :permalink, null: false

      t.timestamps
    end
    add_index :product_groups, :name,       unique: true
    add_index :product_groups, :permalink,  unique: true
  end
end
