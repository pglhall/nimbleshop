class CreateCreditcardTransactions < ActiveRecord::Migration
  def change
    create_table :payment_transactions do |t|
      t.belongs_to  :order,           null: false
      t.string      :transaction_gid, null: false
      t.text        :params,          null: false
      t.boolean     :success,         null: false
      t.string      :operation,       null: false
      t.integer     :amount
      t.text        :additional_info

      t.timestamps
    end
  end
end
