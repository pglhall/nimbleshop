class CreateCreditcards < ActiveRecord::Migration
  def change
    create_table :creditcards do |t|
      t.string :masked_number
      t.datetime :expires_on
      t.string :address1
      t.string :address2
      t.string :zipcode
      t.string :city
      t.string :state
      t.string :card_type
      t.string :first_name
      t.string :last_name
      t.string :email

      t.timestamps
    end
  end
end
