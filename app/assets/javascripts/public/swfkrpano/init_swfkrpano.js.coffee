@init_swfkrpano = () ->
  swf = createswf("http://3dtour.me/cont/tomsk/bar/gulliver/gulliver.swf", "krpano", "740", "560")
  swf.embed("krpano")
