class LinkGroup < ActiveRecord::Base

  has_many :navigations

  liquid_methods :name, :navigations

  before_create :set_permalink

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
