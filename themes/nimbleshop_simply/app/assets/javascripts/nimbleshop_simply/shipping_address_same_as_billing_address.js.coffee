window.NimbleshopSimply = window.NimbleshopSimply || {}

NimbleshopSimply.toggleBillingAddress = class ToggleBillingAddress
  constructor: ->
    @handleToggleCheckBox()
    $("#order_shipping_address_attributes_use_for_billing").on 'click', =>
      @handleToggleCheckBox()

  handleToggleCheckBox: ->
    if $("#order_shipping_address_attributes_use_for_billing").is(':checked')
      $('#billing_well').hide()
    else
      $('#billing_well').show()


$ ->
  new NimbleshopSimply.toggleBillingAddress
