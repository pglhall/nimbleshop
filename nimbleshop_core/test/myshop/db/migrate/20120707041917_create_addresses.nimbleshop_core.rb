# This migration comes from nimbleshop_core (originally 20111109190754)
class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :type
      t.belongs_to :order
      t.string :first_name,         null: false
      t.string :last_name
      t.string :company
      t.string :address1,           null: false
      t.string :address2
      t.string :city,               null: false
      t.string :zipcode
      t.string :country_name,       null: false
      t.string :country_code,       null: false
      t.string :state_name,         null: false
      t.string :state_code
      t.string :phone
      t.string :fax
      t.boolean :use_for_billing,    null: false, default: true

      t.timestamps
    end
  end
end
