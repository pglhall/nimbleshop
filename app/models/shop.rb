class Shop < ActiveRecord::Base

  before_validation :sanitize_twitter_handle

  # TODO
  # make sure that twitter input is accepted with both @ and without @. However store the data without @
  # ensure that facebook url starts with http://www or https://www

  def twitter_url
    twitter_handle.blank? ? nil : "http://twitter.com/#{twitter_handle}"
  end

  private

  def sanitize_twitter_handle
    self.twitter_handle.gsub!(/^@/, '')
  end

end
