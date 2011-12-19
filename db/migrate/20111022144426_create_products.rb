class CreateProducts < ActiveRecord::Migration
  def up
   create_table :products do |t|
      t.string  :name,              null: false
      t.text    :description
      t.integer :price,             null: false
      t.boolean :new,               null: false, default: false
      t.boolean :active,            default: true
      t.string  :picture
      t.string  :permalink,         null: false
      t.timestamps
    end
    add_index :products, :permalink, unique: true
  end

  def down
  end
end
