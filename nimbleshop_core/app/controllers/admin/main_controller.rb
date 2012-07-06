class Admin::MainController < AdminController

  skip_before_filter :set_shop, only: :reset

  def index
    render
  end

end
