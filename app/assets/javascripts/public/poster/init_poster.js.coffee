@init_poster = () ->
  $('.content .info .image a').colorbox
    'maxWidth': '90%'
    'maxHeight': '98%'
    'opacity': '0.5'
    'current': '{current} / {total}'
    'close': 'закрыть'
