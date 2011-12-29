class CreateShops < ActiveRecord::Migration
  def change
    create_table :shops do |t|
      t.string :name,         null: false
      t.string :theme,        null: false, default: 'nootstrap'
      t.string :gateway
      t.string :phone_number
      t.string :twitter_handle
      t.string :contact_email
      t.string :facebook_url
      t.string :company_name_on_creditcard_statements

      t.timestamps
    end
  end
end
