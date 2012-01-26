#
# This module builds permalink when the record is created for the very first time.
#
# Usage:
#
# class Product < ActiveRecord::Base
#   include BuildPermalink
#   build_permalink allow_nil: true
# end
#
# build_permalink line is needed only if you are passing parameter otheriwise that line can be omitted
#
module BuildPermalink
  extend ActiveSupport::Concern

  included do
    before_create :set_permalink
  end

  module ClassMethods
    def build_permalink(options = {})
      unless respond_to?(:max_rating)
        class_inheritable_accessor :permalink_options
        self.permalink_options = options
      end
    end
  end

  module InstanceMethods
    def to_param
      self.permalink
    end

    def set_permalink
      return if self.name.blank? && permalink_options[:allow_nil]
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
