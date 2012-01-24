class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.belongs_to :product
      t.string     :picture
      t.string     :file_name
      t.string     :content_type
      t.string     :file_size

      t.timestamps
    end
  end
end
