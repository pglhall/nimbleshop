class CustomFieldAnswer < ActiveRecord::Base
  belongs_to :product


  belongs_to :custom_field
  alias_method :set_custom_field, :custom_field=

  #this module must be include only after belong_to :custom_field definition
  #this module overrides the dynamic methods which are added by belongs_to
  include Field

  def custom_field=(custom_field)
    set_custom_field(custom_field)

    extend_module
  end
end
