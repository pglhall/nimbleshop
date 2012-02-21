class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.belongs_to :product
      t.string     :picture
      t.string     :file_name
      t.string     :content_type
      t.string     :file_size

      t.string :picture_width
      t.string :picture_height

      t.string :picture_tiny_width
      t.string :picture_tiny_height

      t.string :picture_tiny_plus_width
      t.string :picture_tiny_plus_height

      t.string :picture_small_width
      t.string :picture_small_height

      t.string :picture_small_plus_width
      t.string :picture_small_plus_height

      t.string :picture_medium_width
      t.string :picture_medium_height

      t.string :picture_medium_plus_width
      t.string :picture_medium_plus_height

      t.string :picture_large_width
      t.string :picture_large_height

      t.string :picture_large_plus_width
      t.string :picture_large_plus_height

      t.timestamps
    end
  end
end
