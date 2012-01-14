class CreateVariations < ActiveRecord::Migration
  def change
    create_table :variations do |t|
      t.belongs_to :product

      t.string     :name
      t.string     :default_value
      t.integer    :position,       default: 1
      t.text       :content
      t.text       :variation_type, null: false

      t.timestamps
    end
  end
end
