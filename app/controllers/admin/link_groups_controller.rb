class Admin::LinkGroupsController < AdminController

  def index
    @link_groups = LinkGroup.all
  end

  def show
    @link_group = LinkGroup.find(params[:id])
  end

end
