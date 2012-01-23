//= require jquery-ui
$(document).ready(function() {

  var $link_group_dialog = $('#link-group-form').dialog({ 
    autoOpen: false, 
    modal: true,
    draggable: false
  });

  $('#new-link-group').click(function(){
  	$("div#link-group-form").load("/admin/link_groups/new");
    $link_group_dialog.dialog('open');
  });

  $('a.edit-link-group').click(function(){
  	$("div#link-group-form").load("/admin/link_groups/" + $(this).attr('id') + "/edit");
    $link_group_dialog.dialog('open');
  });

});
