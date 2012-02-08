$(function(){

  $('input:radio').change(function(){
    var $this = $(this), val = $this.val(), form = $this.closest('form');
    if (val === 'paypal')  {
      form.submit();

    } else if (val === 'splitable') {
      $('#post_to_splitable').submit();
    }
  });

});
