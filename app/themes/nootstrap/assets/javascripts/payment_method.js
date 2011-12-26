$(function(){

  $('input:radio').change(function(){
    var $this = $(this), val = $this.val(), form = $this.closest('form');
    if ((val === 'paypal') || (val === 'splitable')) {
      form.submit();
    }
  });

});
