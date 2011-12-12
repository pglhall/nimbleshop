// This JavaScript file adds the feature by which
// clicking on thumbnail displays the image

$('img.thumb').live('click', function(){
  var $this = $(this),
      srcLarge = $this.data('large-picture'),
      srcGrande = $this.data('grande-picture');

  $('#main-image img').attr('src', srcLarge);
  $('#main-image a').attr('href', srcGrande);

  return false;
});
