class Admin::MainController < AdminController

  skip_before_filter :set_shop, only: :reset

  def index
    render
  end

  # this is mostly used for development purpose
  def reset
    reset_session
    redirect_to root_url
  end

end
