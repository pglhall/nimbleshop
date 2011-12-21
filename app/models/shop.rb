class Shop < ActiveRecord::Base

  before_validation :sanitize_twitter_handle

  validates :contact_email, :email => true, :allow_blank => true

  def twitter_url
    twitter_handle.blank? ? nil : "http://twitter.com/#{twitter_handle}"
  end

  private

  def sanitize_twitter_handle
    self.twitter_handle.gsub!(/^@/, '')
  end

end
