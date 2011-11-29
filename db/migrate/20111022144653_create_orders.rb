class CreateOrders < ActiveRecord::Migration
  def up
    create_table :orders do |t|
      t.string :number, null: false
      t.datetime :purchased_at
      t.string :email, null: true

      t.timestamps
    end
    add_index :orders, :number, unique: true
  end

  def down
    remove_index :orders, :column => :number
    drop_table :orders
  end
end
