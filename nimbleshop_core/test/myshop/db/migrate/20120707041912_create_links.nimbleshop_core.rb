# This migration comes from nimbleshop_core (originally 20111031135810)
class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.string :name, null: false
      t.string :url,  null: false

      t.timestamps
    end
  end
end
