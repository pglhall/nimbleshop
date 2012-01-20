class CreateVariations < ActiveRecord::Migration
  def change
    create_table :variations do |t|
      t.belongs_to :product

      t.string     :name,           null: false
      t.text       :content
      t.text       :variation_type, null: false
      t.boolean    :active,         null: false, default: true

      t.timestamps
    end
  end
end
