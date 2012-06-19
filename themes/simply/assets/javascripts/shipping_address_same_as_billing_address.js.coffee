window.App = window.App || {}

App.toggleBillingAddress = ->
  if $("#order_shipping_address_attributes_use_for_billing").is(':checked')
    $('#billing_well').hide()
  else
    $('#billing_well').show()

$ ->
  $("#order_shipping_address_attributes_use_for_billing").bind 'click', App.toggleBillingAddress
  App.toggleBillingAddress()
