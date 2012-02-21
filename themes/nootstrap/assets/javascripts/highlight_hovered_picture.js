$(function(){

  $('#products-index li.product_info').mouseenter(function(){
      $(this).css('border', '1px solid #08c');
    }).mouseleave( function(){
      $(this).css('border', '1px solid #ddd');
    });

});
