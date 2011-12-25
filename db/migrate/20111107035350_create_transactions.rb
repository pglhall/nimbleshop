class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.string  :transaction_gid, null: false
      t.text    :params        ,  null: false
      t.integer :price         ,  null: false
      t.integer :creditcard_id,   null: false
      t.boolean :active,          null: false, default: true
      t.integer :order_id,        null: false
      t.string  :status,          null: false
      t.integer :parent_id,       null: true

      t.timestamps
    end
  end
end
