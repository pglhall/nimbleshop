class CreateProducts < ActiveRecord::Migration
  def change
   create_table :products do |t|
      t.string  :name,              null: false
      t.text    :description
      t.decimal :price,             null: false, precision: 8, scale: 2
      t.boolean :new,               null: false, default: false
      t.boolean :variants_enabled,  null: false, default: false
      t.string  :permalink,         null: false

      t.timestamps
    end
    add_index :products, :permalink, unique: true
  end

end
