@init_schedule_toggle = () ->
  schedule = $(".organization_info .more_schedule")
  schedule.each (index, item) ->
    $('<li class=\'arrow_wrapper\'><span class=\'arrow\'></span></li>').prependTo(schedule)
    link = $('.show_more_schedule', $(item).prev('.work_schedule'))
    return true unless link.position()
    $(item).css
      'top': link.position().top + link.outerHeight(true, true) + 8
      'left': link.position().left
      'z-index': 99999
    link.addClass('clickable').click () ->
      $(item).toggle()
      true
    true
  true
