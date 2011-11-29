class AddressesController < ApplicationController

  layout 'slim'

  theme :theme_resolver, only: [:index, :new]

  def index
    @address = current_order.shipping_address || Address.new
  end

  def new
    current_order.shipping_address = ShippingAddress.new
    current_order.billing_address = BillingAddress.new
  end

  def create
    @address = Address.new(params[:address])
    @address.order_id = current_order.id
    @address.type = 'ShippingAddress'

    respond_to do |format|
      if @address.save
        format.html { redirect_to addresses_path , notice: 'Address was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @address = current_order.shipping_address
    @address.update_attributes(params[:address])
    redirect_to addresses_path
  end

end
