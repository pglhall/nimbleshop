$("a.remove-item").live "click", ->
  $this = $(this)
  permalink = $this.data("permalink")
  $("#updates_" + permalink).val 0
  $("#cartform").submit()
  false
