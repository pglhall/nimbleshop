class Admin::CustomFieldsController < AdminController

  before_filter :load_custom_field, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @custom_fields = CustomField.all
    respond_with @custom_fields
  end

  def edit
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
    respond_to do |format|
      format.html do
        if @custom_field.destroy
          redirect_to admin_custom_fields_path, notice: t(:successfully_deleted)
        else
          redirect_to admin_custom_fields_path, error: t(:could_not_delete)
        end
      end
    end
  end

  private

  def load_custom_field
    @custom_field = CustomField.find(params[:id])
  end

end
