class Admin::LinkGroupsController < AdminController

  before_filter :load_link_group,  only: [:show, :destroy, :edit, :update ]
  before_filter :load_link_groups, only: [:index, :create, :edit, :update ]

  respond_to :html, :js

  def index
    respond_with @link_groups
  end

  def new
    @link_group = LinkGroup.new
    respond_with @link_group
  end

  def edit
    respond_with @link_group
  end

  def create
    respond_to do |format|
      format.html do

  	    @link_group = LinkGroup.new(post_params[:link_group])

        if @link_group.save
          redirect_to admin_link_groups_url, notice: t(:successfully_added)
        else
          render action: 'new'
        end

      end
    end
  end

   def update
     respond_to do |format|
       format.html do

          if @link_group.update_attributes(post_params[:link_group])
            redirect_to admin_link_groups_path, notice: t(:successfully_updated)
          else
            rener action: 'edit'
          end

       end
     end
    end

  def destroy
    respond_to do |format|
      format.html do

        @link_group.destroy
        redirect_to admin_link_groups_url, notice: t(:successfully_deleted)

      end
    end
  end

  private

  def post_params
    params.permit(link_group: [:name])
  end

  def load_link_groups
    @link_groups = LinkGroup.order('id desc')
  end

  def load_link_group
    @link_group = LinkGroup.find_by_permalink!(params[:id])
  end

end
