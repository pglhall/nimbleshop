class AddPositionToPictures < ActiveRecord::Migration
  def change
    add_column :pictures, :position, :integer, default: 0
  end
end