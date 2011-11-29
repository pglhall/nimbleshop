class CreateLinkGroups < ActiveRecord::Migration
  def change
    create_table :link_groups do |t|
      t.string :name,      null: false
      t.string :permalink

      t.timestamps
    end
    add_index(:link_groups, :name, unique: true)
  end
end
