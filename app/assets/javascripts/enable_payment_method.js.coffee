$(".submittable").live "change", ->
  $(this).closest("form").submit()

