class CreatePaypalPaymentNotifications < ActiveRecord::Migration
  def change
    create_table :paypal_payment_notifications do |t|
      t.text   :raw_post
      t.string :order_id,   null: false

      t.timestamps
    end

    add_index :paypal_payment_notifications, :order_id, unique: true
  end
end
