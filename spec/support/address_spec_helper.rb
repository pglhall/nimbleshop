module AddressSpecHelper
  def complete_address_form(kind_of_address, attrs = {})

    %w(first_name last_name address1 address2 city zipcode).each do | attr |
      fill_in "order_#{kind_of_address}_address_attributes_#{attr}", with: attrs[attr.to_sym]
    end

    select  'United States',  from: "order_#{kind_of_address}_address_attributes_country_code"
    select  'Alabama',        from: "order_#{kind_of_address}_address_attributes_state_code"
  end


  def fill_good_address
    address = build(:shipping_address)
    fill_in 'First name',     with: address[:first_name]
    fill_in 'Last name',      with: address[:last_name]
    fill_in 'Address1',       with: address[:address1]
    fill_in 'Address2',       with: 'Highway'
    fill_in 'City',           with: address[:city]
    select  'United States',  from: 'Country code'
    select  'Alabama',        from: 'State code'
    fill_in 'Zipcode',        with:  address[:zipcode]
  end
end
