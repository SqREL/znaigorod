@init_included_photos = () ->
  $('.photogallery ul').jcarousel
    scroll: 5
    visible: 6
  $('.photogallery a').colorbox
    'maxWidth': '90%'
    'maxHeight': '98%'
    'photo': 'true'
    'current': '{current} / {total}'
    'previous': 'предыдущая'
    'next': 'следующая'
    'close': 'закрыть'
  true
