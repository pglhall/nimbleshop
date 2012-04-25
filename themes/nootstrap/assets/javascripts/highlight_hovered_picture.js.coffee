$ ->
  $('#products-index li.product_info, #product_groups-show li.product_info').mouseenter(->
      $(this).css 'border', '1px solid #08c'
    ).mouseleave ->
      $(this).css 'border', '1px solid #ddd'
