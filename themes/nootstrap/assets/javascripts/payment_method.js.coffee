$ ->
  $("input:radio").change ->
    $this = $(this)
    val = $this.val()
    if val is "splitable"
      $this.closest("form").submit()
    else if val is "paypal"
      alert $("form#paypal-payment-form").length
      $("form#paypal-payment-form").submit()

