@init_prepare_sauna = () ->
  $('.sauna_hall_details').each (index, item) ->
    console.log this
    height = Math.max(
      $('.bath', $(this)).outerHeight(true, true),
      $('.pool', $(this)).outerHeight(true, true),
      $('.entertainment', $(this)).outerHeight(true, true)
    )
    $('div', $(this)).outerHeight(height)
  true
