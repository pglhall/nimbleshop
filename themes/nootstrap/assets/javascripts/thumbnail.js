// This JavaScript file adds the feature by which
// mouse enter on thumbnail displays the image

$('img.thumb').live('mouseenter', function(){
  var $this      = $(this);
  var item_index = $('.thumb').index($this) + 1;
  $('.thumbnails li:nth-child('+item_index+')').show().siblings().hide();

  return false;
});

$(document).ready(function () {
  $(".fancybox").fancybox({
    openEffect: 'none',
    closeEffect:'none',
    cyclic: true
  });

});
