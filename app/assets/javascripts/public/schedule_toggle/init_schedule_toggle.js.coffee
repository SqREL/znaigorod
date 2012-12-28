@init_schedule_toggle = () ->
  schedule = $(".organization_info .info .more_schedule")
  $('<li class=\'arrow_wrapper\'><span class=\'arrow\'></span></li>').prependTo(schedule)
  link = $('.time', schedule.prev('.work_schedule'))
  schedule.css
    top: link.position().top + link.outerHeight(true, true) + 8
    left: link.position().left
  link.addClass('clickable').click () ->
    schedule.toggle()
    true
  true
