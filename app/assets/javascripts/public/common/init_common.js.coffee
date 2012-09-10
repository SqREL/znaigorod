@init_common = () ->
  $('a.disabled').click ->
    false

  $('.content .tabs .info .description table tr').each (index, item) ->
    td = $('td:first', this)
    td.text(td.text() + ':')
    true

randomize = (number) ->
  Math.floor(Math.random() * Math.round(number) + 1)
