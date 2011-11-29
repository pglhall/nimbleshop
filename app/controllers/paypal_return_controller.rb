class PaypalReturnController < ApplicationController

  theme :theme_resolver, only: [:handle]

  def handle
    @page_title = "thank you"
    render
  end

end
