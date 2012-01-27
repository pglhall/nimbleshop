$('#new-link-group').live('click', function(){
  $("div#link-group-form").load("/admin/link_groups/new");
  $linkGroupDialog.dialog('open');
});

$('a.edit-link-group').live("click", function(){
  var id = $(this).attr('id');
  $('#link-group-' + id).load("/admin/link_groups/" + id + "/edit", function() {

    $('#form-link-group')
    .bind("ajax:error", function(evt, data, status, xhr){
      alert("There was an error processing your request. It is not your fault. Please try again after a minute.");
    })
    .bind("ajax:success", function(evt, data, status, xhr){
      if (data.success) {
        $(this).find('a.cancel-link-group').trigger('click');
      } else {
        alert(data.error);
      }
    });
  });
});

$("a.cancel-link-group").live("click", function(){
  $(this).parent().parent().load("/admin/link_groups/" + $(this).attr('id'));
});
