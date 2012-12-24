criteria_handler = () ->
  $('.criteria_list ul li a').on 'click', ->
    target = $('#'+$(this).attr('class'))
    $(this).add(target).toggle()
    false

set_previous_state = () ->
  $('.filters_wrapper .hide').hide()
  $('.filters_wrapper .show').each (index, item) ->
    $('.'+$(item).attr('id')).hide()

remove_filter_handler = () ->
  $('.remove_filter_link').on 'click', ->
    filter = $(this).parent()
    filter.find('input').val('').attr('checked', false).change()
    target = $('.'+filter.toggle().attr('id'))
    target.toggle()
    false

clear_form_handler = () ->
  $('.clear_wrapper a').on 'click', ->
    $('.filters_wrapper .filter_inputs input').val('').change()
    $('.filters_wrapper .filter_checkboxes input').attr('checked', false).change()
    $('.filters_wrapper .remove_filter_link:visible').click()
    false

$.fn.draw_scale = (min, max) ->
  middle = (max / 2.0).round()
  scale_block = $(this).before('<div class="scale_block">
                                <span class="min">'+min+'</span>
                                <span class="middle">'+middle+'</span>
                                <span class="max">'+max+'</span>
                              </div>')

filter_slider_handler = () ->
  $('.filter_slider').each (index, item) ->
    $(item).add_handler()

$.fn.add_handler = () ->
  filter_slider = $(this)
  min = filter_slider.data('min')
  max = filter_slider.data('max')
  step = filter_slider.data('step')

  filter_slider.draw_scale(min, max)

  filter_slider.parent().siblings('.filter_inputs').find('input').on 'change', ->
    value = $(this).val()
    if $(this).hasClass('min')
      if value.match(/\d+/)
        filter_slider.slider('values', 0, value)
      else
        filter_slider.slider('values', 0, min)
    if $(this).hasClass('max')
      if value.match(/\d+/)
        filter_slider.slider('values', 1, value)
      else
        filter_slider.slider('values', 1, max)

  filter_slider.slider
    max: max
    min: min
    range: true
    step: step
    values: [min, max]
    create: (event, ui) ->
      filter_slider.parent().find('.ui-corner-all').removeClass('ui-corner-all')
      filter_slider.find('.ui-slider-handle').map (index, item) ->
        $(item).addClass('handle'+index)
      if filter_slider.parent().parent().is(':visible') && filter_slider.parent().parent().hasClass('used')
        filter_slider.slider('values', 0, $(this).parent().siblings('.filter_inputs').find('.min').val())
        filter_slider.slider('values', 1, $(this).parent().siblings('.filter_inputs').find('.max').val())

    slide: (event, ui) ->
      inputs = filter_slider.parent().siblings('.filter_inputs').find('input')
      values = filter_slider.slider('values')
      inputs.map (index, item) ->
        $(item).val(values[index])

    stop: (event, ui) ->
      inputs = filter_slider.parent().siblings('.filter_inputs').find('input')
      values = filter_slider.slider('values')
      inputs.map (index, item) ->
        $(item).val(values[index])

@init_filter_handler = () ->
  set_previous_state()
  remove_filter_handler()
  criteria_handler()
  filter_slider_handler()
  clear_form_handler()
