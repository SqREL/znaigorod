@init_galleria = () ->
  $(".content .gallery_container li").each (index, item) ->
    if $(this).width() < $("img", this).attr("width")
      $(this).css
        position: "relative"
      $("img", this).css
        position: "absolute"
        left: - ($("img", this).attr("width") - $(this).width()) / 2
    $("a", this).attr("rel", "colorbox")
    true
  $(".content .gallery_container li a").colorbox
    "maxWidth": "90%"
    "maxHeight": "98%"
    "opacity": "0.5"
    "current": "{current} / {total}"
    "previous": "предыдущая"
    "next": "следующая"
    "close": "закрыть"
  true
