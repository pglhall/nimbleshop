#= require accounting.js

jQuery ->
  $('[data-behavior~=number-formatted]').on 'focus blur paste change', ()->
    result = accounting.formatNumber($(this).val())
    $(this).val(result)

  $('[data-behavior~=number-formatted]').trigger('change')