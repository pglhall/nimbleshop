$(function(){

  var $linkGroupDialog = $('#link-group-form').dialog({ 
    autoOpen: false, 
    modal: true,
    draggable: false
  });

  $('#new-link-group').click(function(){
  	$("div#link-group-form").load("/admin/link_groups/new");
    $linkGroupDialog.dialog('open');
  });

  $('a.edit-link-group').click(function(){
  	$("div#link-group-form").load("/admin/link_groups/" + $(this).attr('id') + "/edit");
    $linkGroupDialog.dialog('open');
  });

});
