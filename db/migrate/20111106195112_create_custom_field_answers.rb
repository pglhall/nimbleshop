class CreateCustomFieldAnswers < ActiveRecord::Migration
  def change
    create_table :custom_field_answers do |t|
      t.integer   :product_id
      t.integer   :custom_field_id
      t.string    :value
      t.string    :text_value
      t.integer   :number_value
      t.datetime  :datetime_value

      t.timestamps
    end
  end
end
