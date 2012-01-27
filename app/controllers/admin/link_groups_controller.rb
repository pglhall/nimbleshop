class Admin::LinkGroupsController < AdminController

  before_filter :load_link_group, only: [:show, :destroy, :edit, :update ]
  before_filter :load_link_groups, only: [:index, :create, :edit, :update ]

  def index
    render
  end

  def show
    render partial: 'link_group_title', locals: { link_group: @link_group }
  end

  def new
    @link_group = LinkGroup.new
    render partial: 'form'
  end

  def edit
    render partial: 'form'
  end

  def create
  	@link_group = LinkGroup.new(params[:link_group])
    if @link_group.save
      redirect_to admin_link_groups_url, notice: t(:successfully_added)
    else
      render action: :index
    end
  end

   def update
    respond_to do |format|
      format.json do
        if @link_group.update_attributes(params[:link_group])
          render json: { success: @link_group.name }
        else
          render json: { error: @link_group.errors.full_messages }
        end
      end
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
