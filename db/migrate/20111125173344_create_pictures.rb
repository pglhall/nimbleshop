class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.belongs_to :product
      t.string     :picture
      t.string     :picture_file_name
      t.string     :picture_content_type
      t.string     :picture_file_size
      t.string     :picture_updated_at

      t.timestamps
    end
  end
end
