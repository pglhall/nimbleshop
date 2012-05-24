#
# This controller is used to add and delete a link to a link group.
#
class Admin::NavigationsController < AdminController

  before_filter :load_link_group

  def new
    @navigation = @link_group.navigations.new
  end

  def create
    @navigation = @link_group.navigations.build(params[:navigation])

    if @navigation.save
      redirect_to [:admin, :link_groups], notice: "Successfully added"
    else
      render :new, error: "Failed to add"
    end
  end

  def destroy
    @navigation = @link_group.navigations.find_by_id!(params[:id])
    @navigation.destroy

    redirect_to [:admin, :link_groups], notice: "Successfully deleted"
  end

  private

  def load_link_group
    @link_group = LinkGroup.find_by_permalink!(params[:link_group_id])
  end

end
