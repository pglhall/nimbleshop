class CreateCreditcards < ActiveRecord::Migration
  def change
    create_table :creditcards do |t|
      t.string   :masked_number,  null: false
      t.datetime :expires_on,     null: false

      t.timestamps
    end
  end
end
