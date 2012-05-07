class Admin::CustomFieldsController < AdminController

  before_filter :load_custom_field, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @page_title = 'custom fields'
    @custom_fields = CustomField.all
    respond_with @custom_fields
  end

  def show
    @page_title = @custom_field.name
    respond_with @custom_field
  end

  def edit
    @page_title = @custom_field.name
    respond_with @custom_field
  end

  def update
    if @custom_field.update_attributes(params[:custom_field])
      redirect_to admin_custom_fields_path, notice: t(:successfully_updated)
    else
      respond_with @custom_field
    end
  end

  def new
    @page_title = 'new custom field'
    @custom_field = CustomField.new
    respond_with @custom_field
  end

  def create
    @custom_field  = CustomField.new(params[:custom_field])
    if @custom_field.save
      redirect_to admin_custom_fields_url, notice: t(:successfully_added)
    else
      respond_with @custom_field
    end
  end

  def destroy
    if @custom_field.destroy
      redirect_to admin_custom_fields_path, notice: t(:successfully_deleted)
    else
      redirect_to admin_custom_fields_path, error: t(:could_not_delete)
    end
  end

  private

    def load_custom_field
      @custom_field = CustomField.find(params[:id])
    end

end
