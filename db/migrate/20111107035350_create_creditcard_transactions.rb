class CreateCreditcardTransactions < ActiveRecord::Migration
  def change
    create_table :creditcard_transactions do |t|
      t.belongs_to :order,        null: false
      t.string  :transaction_gid, null: false
      t.text    :params,          null: false
      t.decimal :amount,          null: false, precision: 8, scale: 2
      t.integer :creditcard_id,   null: false
      t.boolean :active,          null: false, default: true
      t.string  :status,          null: false
      t.integer :parent_id,       null: true

      t.timestamps
    end

    create_table :paypal_transactions do |t|
      t.text       :params,   null: true
      t.belongs_to :order,    null: false
      t.string     :status,   null: true
      t.decimal    :amount,   null: false, precision: 8, scale: 2
      t.string     :txn_id,   null: true
      t.string     :txn_type, null: true
    end
  end
end
