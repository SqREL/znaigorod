
@init_affiches_filter = () ->

  link = $($('.affiches_filter .periods .daily').children()[0])
  wrapper = link.closest('li')

  cal = $('<input id="ui-calendar" type="text" />').appendTo('body').datepicker
    dateFormat: "yy-mm-dd"
    onSelect: (dateText, inst) ->
      link.text("#{inst.selectedDay} #{russian_monthes[inst.selectedMonth]}")
      year = inst.selectedYear
      month = if inst.selectedMonth + 1 < 10 then "0#{inst.selectedMonth + 1}" else inst.selectedMonth + 1
      day = if inst.selectedDay < 10 then "0#{inst.selectedDay}" else inst.selectedDay
      date = "#{year}-#{month}-#{day}"

      location = window.location.pathname.split('/')
      location[2] = 'daily'
      if typeof location[3] != "undefined" && location[3] != null
        if location[3].match /\d{4}-\d{1,2}-\d{1,2}/
          location[3] = date
        else
          location.splice(3, 0, date)
      else
        location[3] = date
      window.location.pathname = location.join('/')

      true
  location = window.location.pathname.split('/')
  if typeof location[3] != "undefined" && location[3] != null && location[3].match /\d{4}-\d{1,2}-\d{1,2}/
    cal.datepicker('setDate', location[3])
  else if location[2] == 'daily'
    current_date = new Date
    cal.datepicker('setDate', current_date.toLocaleFormat('%Y-%m-%d'))
  cal.css
    'top': wrapper.position().top
    'left': wrapper.position().left
    'width': wrapper.outerWidth()
    'height': wrapper.outerHeight()

  link.click (event) ->
    if cal.datepicker('widget').is(':hidden')
      cal.datepicker('show')
    else
      cal.datepicker('hide')
    false

  true

@russian_monthes = [
  "января"
  "февраля"
  "марта"
  "апреля"
  "мая"
  "июня"
  "июля"
  "августа"
  "сентября"
  "октября"
  "ноября"
  "декабря"
]
