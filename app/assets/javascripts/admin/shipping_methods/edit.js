$(function() {
  $(".update-shipping").live("ajax:success", function(t, result) {
     $(t.target).parents('tr').replaceWith(result.html);
  });
});
