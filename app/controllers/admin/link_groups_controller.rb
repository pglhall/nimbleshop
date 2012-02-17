class Admin::LinkGroupsController < AdminController

  before_filter :load_link_group,  only: [:show, :destroy, :edit, :update ]
  before_filter :load_link_groups, only: [:index, :create, :edit, :update ]

  def index
    @page_title = 'link groups'
  end

  def show
    render partial: 'link_group_title', locals: { link_group: @link_group }
  end

  def new
    @link_group = LinkGroup.new
  end

  def edit
    render
  end

  def create
  	@link_group = LinkGroup.new(params[:link_group])
    if @link_group.save
      redirect_to admin_link_groups_url, notice: t(:successfully_added)
    else
      render action: :new
    end
  end

   def update
      if @link_group.update_attributes(params[:link_group])
        redirect_to admin_link_groups_path, notice: t(:successfully_updated)
      else
        render action: :edit
      end
    end

  def destroy
    @link_group.destroy
    redirect_to admin_link_groups_url, notice: t(:successfully_deleted)
  end

  private

  def load_link_groups
    @link_groups = LinkGroup.order('name asc')
  end

  def load_link_group
    @link_group = LinkGroup.find_by_permalink!(params[:id])
  end

end
