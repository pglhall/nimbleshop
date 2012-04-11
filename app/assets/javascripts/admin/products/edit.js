$(function() {
  $('.nested-form .fields').hide();

  $('.product_pictures .actions .delete').on('click', function() {
    $('#delete_picture_'+$(this).attr('data-action-id')).trigger('click');
    $(this).parent().parent().hide('fast')
    return false;
  });

  $('.product_pictures').sortable({
    // cancel: 'img',
    update: function(e, ui) {
      orders = {}
      $('.product_pictures li').each(function(index, el) {
        orders[index] = $(el).attr('data-id')
      });

      $('#product_pictures_order').attr('value', $.toJSON(orders));
    }
  }).disableSelection();
});

