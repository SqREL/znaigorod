@init_galleria = () ->
  $(".content .gallery_container li").each (index, item) ->
    if $(this).width() < $("img", this).attr("width")
      $(this).css
        position: "relative"
      $("img", this).css
        position: "absolute"
        left: - ($("img", this).attr("width") - $(this).width()) / 2
    true
  true
