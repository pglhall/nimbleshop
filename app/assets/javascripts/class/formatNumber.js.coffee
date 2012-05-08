#= require accounting.js

jQuery ->
  $('[data-behavior~=number-formatted]').on 'focus blur paste change', ()->

    precision = $(this).data('behavior-precision');
    if precision is undefined
      precision = accounting.settings.number.precision

    result = accounting.formatNumber($(this).val(), precision)
    $(this).val(result)

  $('[data-behavior~=number-formatted]').trigger('change')