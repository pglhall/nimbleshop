#= require accounting.js

jQuery ->
  $('[data-behavior~=price-formatted]').on 'focus blur paste change', ()->

    # do not want comma in cases like 1,234.89
    # do not want $ to be appearing like $23.78
    result = accounting.formatMoney($(this).val(), {thousand: '', symbol: ''})

    $(this).val(result)

  $('[data-behavior~=price-formatted]').trigger('change')