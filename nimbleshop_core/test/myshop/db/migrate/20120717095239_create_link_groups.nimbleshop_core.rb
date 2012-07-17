# This migration comes from nimbleshop_core (originally 20111026193227)
class CreateLinkGroups < ActiveRecord::Migration
  def change
    create_table :link_groups do |t|
      t.string :name,      null: false
      t.string :permalink, null: false

      t.timestamps
    end
    add_index :link_groups, :name,      unique: true
    add_index :link_groups, :permalink, unique: true
  end
end
