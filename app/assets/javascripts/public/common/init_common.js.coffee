@init_common = () ->
  $('a.disabled').click ->
    false

randomize = (number) ->
  Math.floor(Math.random() * Math.round(number) + 1)
