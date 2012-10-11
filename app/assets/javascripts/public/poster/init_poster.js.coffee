@init_poster = () ->
  $('.content .info .image a').colorbox
    'maxWidth': '90%'
    'maxHeight': '95%'
    'opacity': '0.5'
    'current': '{current} / {total}'
    'close': 'закрыть'
