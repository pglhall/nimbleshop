class Admin::ShopsController < AdminController

  respond_to :html

  def edit
    respond_with(:admin, current_shop)
  end

  def update
    if current_shop.update_attributes(post_params[:shop])
      redirect_to edit_admin_shop_path, notice: 'Shop was successfully updated'
    else
      respond_with(:admin, current_shop)
    end
  end

  private

  def post_params
    params.permit(shop: [ :name,
                          :theme,
                          :author_name,
                          :description,
                          :time_zone,
                          :from_email,
                          :default_creditcard_action,
                          :twitter_handle,
                          :facebook_url,
                          :google_analytics_tracking_id,
                          :tax_percentage])
  end

end
