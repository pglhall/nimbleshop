class Admin::LinkGroupsController < AdminController

  before_filter :load_link_group,  only: [:show, :destroy, :edit, :update ]
  before_filter :load_link_groups, only: [:index, :create, :edit, :update ]

  respond_to :html, :js

  def index
    @page_title = 'link groups'
    respond_with @link_groups
  end

  def show
    @page_title = @link_group.name
    respond_with @link_group
  end

  def new
    @page_title = 'new link group'
    @link_group = LinkGroup.new
    respond_with @link_group
  end

  def edit
    @page_title = @link_group.name
    respond_with @link_group
  end

  def create
  	@link_group = LinkGroup.new(post_params[:link_group])
    if @link_group.save
      redirect_to admin_link_groups_url, notice: t(:successfully_added)
    else
      respond_with @link_group
    end
  end

   def update
      if @link_group.update_attributes(post_params[:link_group])
        redirect_to admin_link_groups_path, notice: t(:successfully_updated)
      else
        respond_with @link_group
      end
    end

  def destroy
    @link_group.destroy
    redirect_to admin_link_groups_url, notice: t(:successfully_deleted)
  end

  private

    def post_params
      params.permit(link_group: [:name])
    end

    def load_link_groups
      @link_groups = LinkGroup.order('name asc')
    end

    def load_link_group
      @link_group = LinkGroup.find_by_permalink!(params[:id])
    end

end
