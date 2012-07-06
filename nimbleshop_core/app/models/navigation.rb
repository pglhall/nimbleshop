class Navigation < ActiveRecord::Base
  belongs_to :link_group
  belongs_to :product_group

  validates  :link_group,     presence: true
  validates  :product_group,  presence: true
end
