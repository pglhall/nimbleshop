# This migration comes from nimbleshop_core (originally 20111106193938)
class CreateCustomFields < ActiveRecord::Migration
  def change
    create_table :custom_fields do |t|
      t.string :name,       null: false
      t.string :field_type, null: false

      t.timestamps
    end
  end
end
