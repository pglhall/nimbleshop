$(function(){

  $("a.ship_items_link").click(function(){
    $(this).hide();
    $('#ship_items_action_box').show();
    return false;
  });

});


$('#ship_items_cancel').live('click', function(){
  $("a.ship_items_link").show();
  $('#ship_items_action_box').hide();
});
