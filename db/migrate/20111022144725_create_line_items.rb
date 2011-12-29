class CreateLineItems < ActiveRecord::Migration
  def change
    create_table :line_items do |t|
      t.belongs_to :order,    null: false
      t.belongs_to :product,  null: false
      t.integer    :quantity, null: false

      t.timestamps
    end
    add_index(:line_items, [:order_id, :product_id], unique: true)
  end
end
