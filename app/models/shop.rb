class Shop < ActiveRecord::Base

  def link_groups
    LinkGroup.all
  end

  def self.using_website_payments_standard?
    false
  end

end
