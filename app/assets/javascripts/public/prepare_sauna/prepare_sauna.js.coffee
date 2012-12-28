@init_prepare_sauna = () ->
  height = Math.max(
    $('.sauna_hall_details .bath').outerHeight(true, true),
    $('.sauna_hall_details .pool').outerHeight(true, true),
    $('.sauna_hall_details .entertainment').outerHeight(true, true)
  )
  $('.sauna_hall_details div').outerHeight(height)
  true
