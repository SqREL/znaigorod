@init_poster = () ->
  $('.content .info .image a, .organization_info .info .image a').colorbox
    'maxWidth': '90%'
    'maxHeight': '98%'
    'photo': 'true'
    'current': '{current} / {total}'
    'previous': 'предыдущая'
    'next': 'следующая'
    'close': 'закрыть'
