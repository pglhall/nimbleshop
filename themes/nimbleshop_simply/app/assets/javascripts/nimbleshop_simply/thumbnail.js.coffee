# mouse enter on thumbnail displays the image on the product show page

$ ->
  $("img.thumb").on "mouseenter", ->
    $this = $(this)
    itemIndex = $(".thumb").index($this) + 1
    $(".thumbnails li:nth-child(" + itemIndex + ")").show().siblings().hide()
    false
