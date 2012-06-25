#
# This controller is used to add and delete a link from a link group.
#
class Admin::NavigationsController < AdminController

  before_filter :load_link_group

  respond_to :html

  def new
    @navigation = @link_group.navigations.new
    respond_with @navigation
  end

  def create
    respond_to do |format|
      format.html do

        @navigation = @link_group.navigations.build(params[:navigation])

        if @navigation.save
          redirect_to [:admin, :link_groups], notice: t(:successfully_added)
        else
          render :new, error: 'Failed to add'
        end

      end
    end
  end

  def destroy
    respond_to do |format|
      format.html do

        @navigation = @link_group.navigations.find_by_id!(params[:id])
        @navigation.destroy
        redirect_to [:admin, :link_groups], notice: t(:successfully_deleted)

      end
    end
  end

  private

  def load_link_group
    @link_group = LinkGroup.find_by_permalink!(params[:link_group_id])
  end

end
