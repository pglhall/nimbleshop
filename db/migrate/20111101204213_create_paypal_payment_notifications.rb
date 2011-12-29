class CreatePaypalPaymentNotifications < ActiveRecord::Migration
  def change
    create_table :paypal_payment_notifications do |t|
      t.text   :params
      t.string :order_number,   null: false
      t.string :status,         null: false
      t.string :transaction_id, null: false

      t.timestamps
    end

    add_index :paypal_payment_notifications, :order_number, unique: true
  end
end
