class CreateProductGroupConditions < ActiveRecord::Migration
  def change
    create_table :product_group_conditions do |t|
      t.belongs_to :product_group
      t.string :column_name,       null: false
      t.string :operator,          null: false
      t.integer :value_integer

      t.timestamps
    end
  end
end
