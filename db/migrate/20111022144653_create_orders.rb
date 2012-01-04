class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string     :number,             null: false
      t.belongs_to :shipping_method,    null: true
      t.belongs_to :payment_method,     null: true
      t.datetime   :purchased_at,       null: true
      t.string     :email,              null: true
      t.string     :status,             null: false, default: 'added_to_cart'

      t.timestamps
    end
    add_index :orders, :number, unique: true
  end

end
