$ ->
  $(".nimbleshop-payment-method-form .cancel").click ->
    $this = $(this)
    div = $this.closest(".nimbleshop-payment-method-form-well")
    div.hide()  if div.length
    false

  $(".nimbleshop-payment-method-edit").click ->
    console.log "clicked"
    $this = $(this)
    well = $this.parent("div").find(".nimbleshop-payment-method-form-well")
    if well.length
      if well.is(":visible")
        well.hide()
      else
        well.show()
    false
