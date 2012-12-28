@init_organization_photos = () ->
  $('.organization_info .photogallery ul').jcarousel
    scroll: 5
    visible: 6
  $('.organization_info .photogallery a').colorbox
    'maxWidth': '90%'
    'maxHeight': '98%'
    'photo': 'true'
    'current': '{current} / {total}'
    'previous': 'предыдущая'
    'next': 'следующая'
    'close': 'закрыть'
  true
