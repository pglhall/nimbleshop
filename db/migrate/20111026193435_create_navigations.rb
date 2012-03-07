class CreateNavigations < ActiveRecord::Migration
  def change
    create_table :navigations do |t|
      t.belongs_to :link_group,     null: false
      t.belongs_to :product_group,  null: false

      t.timestamps
    end
  end
end
