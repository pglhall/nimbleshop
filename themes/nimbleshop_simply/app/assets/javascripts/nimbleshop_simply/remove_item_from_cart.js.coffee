$ ->
  $("a.remove-item").on "click", ->
    $this = $(this)
    permalink = $this.data("permalink")
    $("#updates_" + permalink).val 0
    $("#cartform").submit()
    false
