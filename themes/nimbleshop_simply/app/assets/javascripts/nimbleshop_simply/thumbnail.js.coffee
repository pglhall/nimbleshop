# This JavaScript file adds the feature by which
# mouse enter on thumbnail displays the image

$("img.thumb").live "mouseenter", ->
  $this = $(this)
  item_index = $(".thumb").index($this) + 1
  $(".thumbnails li:nth-child(" + item_index + ")").show().siblings().hide()
  false

$ ->
  $(".fancybox").fancybox
    openEffect: "none"
    closeEffect: "none"
    cyclic: true
