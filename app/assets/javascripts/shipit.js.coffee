$ ->
  $("a.ship_items_link").click ->
    $(this).hide()
    $("#ship_items_action_box").show()
    false


$("#ship_items_cancel").live "click", ->
  $("a.ship_items_link").show()
  $("#ship_items_action_box").hide()
