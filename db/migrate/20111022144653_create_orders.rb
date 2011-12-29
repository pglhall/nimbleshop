class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string     :number,             null: false
      t.belongs_to :shipping_method
      t.datetime   :purchased_at
      t.string     :email,              null: true
      t.string     :status,             default: 'added_to_cart'

      t.timestamps
    end
    add_index :orders, :number, unique: true
  end

end
