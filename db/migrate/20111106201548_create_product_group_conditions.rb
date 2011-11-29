class CreateProductGroupConditions < ActiveRecord::Migration
  def change
    create_table :product_group_conditions do |t|
      t.integer :product_group_id
      t.string :column_name
      t.string :operator
      t.integer :value_integer

      t.timestamps
    end
  end
end
