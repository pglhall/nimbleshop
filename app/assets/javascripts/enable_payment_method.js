$('.submittable').live('change', function() {
  $(this).closest('form').submit();
});
