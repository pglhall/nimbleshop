class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :creditcard_transactions do |t|
      t.string  :transaction_gid, null: false
      t.text    :params,          null: false
      t.integer :amount,          null: false
      t.integer :creditcard_id,   null: false
      t.boolean :active,          null: false, default: true
      t.integer :order_id,        null: false
      t.string  :status,          null: false
      t.integer :parent_id,       null: true

      t.timestamps
    end

    create_table :paypal_transactions do |t|
      t.text    :params,   null: true
      t.integer :order_id, null: false
      t.string  :status,   null: true
      t.integer :amount,   null: false
      t.string  :invoice,  null: false
    end
  end
end
