$(function(){
  $('.autoresize').autoResize({maxHeight: 300});
});


  $(function(){
    $('.cancel').click(function(){
      var $this = $(this);
      var div = $this.closest('.nimbleshop-payment-method-form-well');
      if (div.length) {
        div.hide();
      }
      return false;
    });

    $('.nimbleshop-payment-method-edit').click(function(){
      console.log('clicked');
      var $this = $(this);
      var well = $this.parent('div').find('.nimbleshop-payment-method-form-well');
      console.log(well.length);
      if (well.length) {
        if (well.is(':visible')) {
          well.hide();
        } else {
          well.show();
        }
      }
      return false;
    });
  });
