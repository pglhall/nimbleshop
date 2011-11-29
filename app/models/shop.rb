class Shop < ActiveRecord::Base

  liquid_methods :link_groups, :phone_number, :contact_email, :twitter_handle, :facebook_url

  def link_groups
    LinkGroup.all
  end

  def self.using_website_payments_standard?
    false
  end


end
