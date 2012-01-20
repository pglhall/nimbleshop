$(function(){

  $('.variants').find('select').change(function(e){

    var variation1Value = $('#variation1_value').val(),
        variation2Value = $('#variation2_value').val(),
        variation3Value = $('#variation3_value').val(),
        key             = '',
        $productShowVariantPriceData = $('#product-show-variant-price-data'),
        $productPrice   = $('#product-price'),
        $addToCart      = $('#add-to-cart'),
        newPrice;

     if (!(variation1Value === undefined)) {
        key = key + variation1Value;
     }

     if (!(variation2Value === undefined)) {
        key = key + variation2Value;
     }

     if (!(variation3Value === undefined)) {
        key = key + variation3Value;
     }

     newPrice = $productShowVariantPriceData.data('fields')[key];
     console.log(newPrice);
     if (newPrice) {
      $productPrice.text(accounting.formatMoney(newPrice));
      $addToCart.removeClass('disabled').removeAttr('disabled');
     } else {
      $productPrice.text('Not available');
      $addToCart.addClass('disabled').attr('disabled', 'disabled');
     }

     $productPrice.effect("highlight", {}, 1000);

  });

});
