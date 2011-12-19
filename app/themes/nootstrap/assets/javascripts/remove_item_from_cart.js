$(function(){
  $('a.remove-item').bind('click', function(){
    var $this = $(this),
        permalink = $this.data('permalink');
    $('#updates_'+permalink).val(0);
    $('#cartform').submit();
    return false;
  });
});
