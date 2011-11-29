class PagesController < ApplicationController

  theme :theme_resolver, only: [:show]

  def show
    @page = Page.find_by_permalink!(params[:id])
  end

end
