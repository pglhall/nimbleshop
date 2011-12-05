class CreatePaymentMethods < ActiveRecord::Migration
  def change
    create_table :payment_methods do |t|
      t.boolean :enabled, default: false
      t.string  :name
      t.text    :description
      t.text    :credentials
      t.string :permalink, null: false

      t.timestamps
    end
    add_index(:payment_methods, :permalink, unique: true)
  end
end
