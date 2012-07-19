$ ->
  $("a.ship-items-link").on 'click', ->
    $(this).hide()
    $("#ship_items_action_box").show()
    false

  $("#ship_items_cancel").on "click", ->
    $("a.ship-items-link").show()
    $("#ship_items_action_box").hide()
    false
