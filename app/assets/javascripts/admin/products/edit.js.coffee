$ ->
  $(".nested-form .fields").hide()
  $(".product_pictures .actions .delete").on "click", ->
    $("#delete_picture_" + $(this).attr("data-action-id")).trigger "click"
    $(this).parent().parent().hide "fast"
    false

  $(".product_pictures").sortable(update: (e, ui) ->
    orders = {}
    $(".product_pictures li").each (index, el) ->
      orders[index] = $(el).attr("data-id")

    $("#product_pictures_order").attr "value", $.toJSON(orders)
  ).disableSelection()
