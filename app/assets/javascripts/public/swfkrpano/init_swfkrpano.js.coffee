@init_swfkrpano = () ->
  link = $("#krpano a.tour_link")
  if link.length
    swf = createswf(link.attr("href"), "krpano", "740", "560")
    swf.embed("krpano")
    link.remove()
  false
