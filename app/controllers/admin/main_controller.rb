class Admin::MainController < AdminController

  skip_before_filter :set_shop, only: :reset

  def index
    render
  end

  def change_theme
    @shop.update_attributes(theme: params[:theme])
  end

  def reset
    reset_session
    redirect_to '/admin', notice: 'done'
  end

end
