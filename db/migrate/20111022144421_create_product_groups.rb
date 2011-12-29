class CreateProductGroups < ActiveRecord::Migration
  def change
    create_table :product_groups do |t|
      t.string :name,      null: false
      t.string :permalink, null: false
      t.string :condition, null: false

      t.timestamps
    end
    add_index :product_groups, :name,       unique: true
    add_index :product_groups, :permalink,  unique: true
  end
end
