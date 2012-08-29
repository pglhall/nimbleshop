$ ->
  $('[data-behavior~=remove-item-from-cart]').on 'click', ->
    $this = $(this)
    permalink = $this.data("permalink")
    $("#updates_" + permalink).val 0
    $("#cartform").submit()
    false
