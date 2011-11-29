class CreatePictures < ActiveRecord::Migration
  def up
    create_table :pictures do |t|
      t.integer :product_id
      t.string  :picture
      t.string  :picture_file_name
      t.string  :picture_content_type
      t.string  :picture_file_size
      t.string  :picture_updated_at
      t.timestamps
    end
  end

  def down
    drop_table :pictures
  end
end
