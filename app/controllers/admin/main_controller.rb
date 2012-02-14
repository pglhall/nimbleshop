class Admin::MainController < AdminController

  skip_before_filter :set_shop, only: :reset

  def index
    render
  end

  def reset
    reset_session
    redirect_to '/admin', notice: 'done'
  end

end
