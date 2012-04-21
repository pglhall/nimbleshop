$(function(){

  $('input:radio').change(function(){
    var $this = $(this), val = $this.val(), form = $this.closest('form');

    if (val === 'splitable') {
      form.submit();
    } else if (val === 'paypal') {
      $('form#paypal-payment-form').submit();
    }

  });

});
