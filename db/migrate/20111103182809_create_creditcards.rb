class CreateCreditcards < ActiveRecord::Migration
  def change
    create_table :creditcards do |t|
      t.string   :masked_number
      t.datetime :expires_on

      t.timestamps
    end
  end
end
