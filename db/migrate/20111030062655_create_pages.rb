class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :name,        null: false
      t.string :permalink,   null: false
      t.text :content

      t.timestamps
    end

    add_index :pages, :permalink, unique: true
  end
end
