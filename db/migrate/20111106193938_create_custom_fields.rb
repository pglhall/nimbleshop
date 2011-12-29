class CreateCustomFields < ActiveRecord::Migration
  def change
    create_table :custom_fields do |t|
      t.string :name,       null: false
      t.string :field_type, null: false

      t.timestamps
    end
  end
end
