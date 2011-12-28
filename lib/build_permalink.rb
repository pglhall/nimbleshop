#
# This module builds permalink when the record is created for the very first time.
#
# Usage:
#
# class Product < ActiveRecord::Base
#   include BuildPermalink
# end
#
module BuildPermalink
  extend ActiveSupport::Concern

  included do
    before_create :set_permalink
  end

  module InstanceMethods
    def to_param
      self.permalink
    end

    def set_permalink
      permalink = self.name.parameterize
      counter = 2

      while self.class.exists?(permalink: permalink) do
        permalink = "#{permalink}-#{counter}"
        counter = counter + 1
      end

      self.permalink ||= permalink
    end
  end
end
