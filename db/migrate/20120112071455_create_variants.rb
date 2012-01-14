class CreateVariants < ActiveRecord::Migration
  def change
    create_table :variants do |t|
      t.belongs_to :product

      t.string     :variation1_value
      t.string     :variation1_parameterized, default: ''
      t.string     :variation2_value
      t.string     :variation2_parameterized, default: ''
      t.string     :variation3_value
      t.string     :variation3_parameterized, default: ''

      t.decimal    :price,             null: false, precision: 8, scale: 2

      t.timestamps
    end
  end
end
