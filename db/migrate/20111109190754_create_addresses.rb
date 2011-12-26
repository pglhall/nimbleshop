class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :type
      t.integer :order_id
      t.string :first_name
      t.string :last_name
      t.string :company
      t.string :address1
      t.string :address2
      t.string :city
      t.string :zipcode
      t.string :country
      t.string :state
      t.string :phone
      t.string :fax
      t.boolean :use_for_billing

      t.timestamps
    end
  end
end
