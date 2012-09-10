@init_poster = () ->
  $('.content .tabs .image a').colorbox
    'maxWidth': '90%'
    'maxHeight': '95%'
    'opacity': '0.5'
    'current': '{current} / {total}'
    'close': 'закрыть'
