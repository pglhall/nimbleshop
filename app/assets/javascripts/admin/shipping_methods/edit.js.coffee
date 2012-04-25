$ ->
  $(".update-shipping").live "ajax:success", (t, result) ->
    $(t.target).parents("tr").replaceWith result.html

