class Navigation < ActiveRecord::Base
  belongs_to :link_group
  belongs_to :navigeable, polymorphic: true
end
