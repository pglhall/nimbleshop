$ ->
  $("input:radio").change ->
    $this = $(this)
    val = $this.val()
    form = $this.closest("form")
    if val is "splitable"
      form.submit()
    else $("form#paypal-payment-form").submit()  if val is "paypal"

