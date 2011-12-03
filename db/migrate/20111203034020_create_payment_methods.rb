class CreatePaymentMethods < ActiveRecord::Migration
  def change
    create_table :payment_methods do |t|
      t.boolean :enabled, default: false
      t.string  :name
      t.text    :description

      t.timestamps
    end
  end
end
