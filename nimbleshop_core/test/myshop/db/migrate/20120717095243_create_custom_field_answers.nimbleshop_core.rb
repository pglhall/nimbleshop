# This migration comes from nimbleshop_core (originally 20111106195112)
class CreateCustomFieldAnswers < ActiveRecord::Migration
  def change
    create_table :custom_field_answers do |t|
      t.belongs_to :product
      t.belongs_to :custom_field
      t.string    :value
      t.string    :text_value
      t.integer   :number_value
      t.datetime  :datetime_value

      t.timestamps
    end
  end
end
