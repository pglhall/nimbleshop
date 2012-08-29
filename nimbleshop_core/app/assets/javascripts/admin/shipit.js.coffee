$ ->
  $('[data-behavior~=ship-items]').on 'click', ->
    $(this).hide()
    $('[data-behavior~=ship-items-box]').show()
    false

  $('[data-behavior~=ship-items-cancel]').on 'click', ->
    $('[data-behavior~=ship-items]').show()
    $('[data-behavior~=ship-items-box]').hide()
    false
