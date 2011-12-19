$(function(){

  $('span.fieldWithErrors').each(function(){
    var $this = $(this);
    $this.find('input').addClass('error');
    $this.closest('.clearfix').addClass('error');
  });

});
