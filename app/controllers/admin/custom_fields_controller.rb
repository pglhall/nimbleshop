class Admin::CustomFieldsController < AdminController

  def index
    @custom_fields = CustomField.all
  end

  def show
    @custom_field = CustomField.find(params[:id])
  end

  def edit
    @custom_field = CustomField.find(params[:id])
  end

  def update
    @custom_field = CustomField.find(params[:id])
    if @custom_field.update_attributes(params[:custom_field])
      redirect_to admin_custom_fields_path, notice: "Successfully updated"
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
      redirect_to admin_custom_fields_url, notice: 'Successfully added'
    else
      render action: :new
    end
  end


end
