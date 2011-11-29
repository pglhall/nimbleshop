class CreatePaypalPaymentNotifications < ActiveRecord::Migration
  def change
    create_table :paypal_payment_notifications do |t|
      t.text :params
      t.string :order_number
      t.string :status
      t.string :transaction_id

      t.timestamps
    end
  end
end
