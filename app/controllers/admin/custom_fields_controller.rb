class Admin::CustomFieldsController < AdminController

  before_filter :load_custom_filed, only: [:show, :edit, :update, :destroy]

  def index
    @custom_fields = CustomField.all
  end

  def show
    render
  end

  def edit
    render
  end

  def update
    if @custom_field.update_attributes(params[:custom_field])
      redirect_to admin_custom_fields_path, notice: t(:successfully_updated)
    else
      render :action => 'edit'
    end
  end

  def new
    @custom_field = CustomField.new
  end

  def create
    @custom_field  = CustomField.new(params[:custom_field])
    if @custom_field.save
      redirect_to admin_custom_fields_url, notice: t(:successfully_added)
    else
      render action: :new
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
