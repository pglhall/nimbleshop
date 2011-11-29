class Admin::ShopsController < AdminController

  def change_theme
    @shop.update_attribute(:theme, params[:theme])
    redirect_to root_url
  end

  def show
    render
  end

end
