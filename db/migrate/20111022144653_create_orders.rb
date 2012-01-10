class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string     :number,             null: false
      t.belongs_to :shipping_method,    null: true
      t.belongs_to :payment_method,     null: true
      t.datetime   :purchased_at,       null: true
      t.string     :email,              null: true
      t.string     :status,             null: false, default: 'open'
      t.string     :payment_status,     null: false, default: 'abandoned_early'
      t.string     :shipping_status,    null: false, default: 'nothing_to_ship'
      t.string     :checkout_status,    null: false, default: 'items_added_to_cart'

      t.timestamps
    end
    add_index :orders, :number, unique: true
  end

end
