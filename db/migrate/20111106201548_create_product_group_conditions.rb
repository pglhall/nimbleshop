class CreateProductGroupConditions < ActiveRecord::Migration
  def change
    create_table :product_group_conditions do |t|
      t.belongs_to :product_group
      t.string  :name,      null: false
      t.string  :operator,  null: false
      t.string :value

      t.timestamps
    end
  end
end
