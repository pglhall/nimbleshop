class CreateNavigations < ActiveRecord::Migration
  def change
    create_table :navigations do |t|
      t.integer :link_group_id,     null: false
      t.references :navigeable,     polymorphic: true

      t.timestamps
    end
  end
end
