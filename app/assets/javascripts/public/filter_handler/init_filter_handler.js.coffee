get_params_from_customslider = (context, min_key, max_key) ->
  params = {}
  slider = $('#'+context)
  slider_parent = slider.parent()
  min = slider.customslider('values', 0)
  max = slider.customslider('values', 1) - 1
  min_value =  slider_parent.find('.item_'+min).attr('data-value')
  max_value =  slider_parent.find('.item_'+max).attr('data-value')
  params[min_key] = min_value
  params[max_key] = max_value

  params

get_params_from_checker = (context, key) ->
  params = {}

  buf = []
  $('.'+context+' ul .active').each ->
    buf.push $(this).attr('data-value')
  params[key] = buf

  params

$.fn.prepare_params = () ->
  $this = $(this)
  params = {}

  $this.find('.filter').each ->
    context = $(this).attr('class').replace('filter ', '')

    switch context
      when 'by_date'
        $.extend params, get_params_from_customslider(context, 'starts_on_gt', 'starts_on_lt')
        break

      when 'by_time'
        $.extend params, get_params_from_customslider(context, 'starts_at_hour_gt', 'starts_at_hour_lt')
        break

      when 'by_amount'
        $.extend params, get_params_from_customslider(context, 'price_gt', 'price_lt')
        break

      when 'by_affiche_category'
        $.extend params, get_params_from_checker(context, 'affiche_category')
        break

      when 'by_category'
        $.extend params, get_params_from_checker(context, 'category')
        break

      when 'by_tag'
        $.extend params, get_params_from_checker(context, 'tags')
        break

      when 'by_cuisine'
        $.extend params, get_params_from_checker(context, 'cuisine')
        break

      when 'by_payment'
        $.extend params, get_params_from_checker(context, 'payment')
        break

      when 'by_feature'
        $.extend params, get_params_from_checker(context, 'feature')
        break

      when 'by_offer'
        $.extend params, get_params_from_checker(context, 'offer')
        break

  { utf8: true, search: params }

@init_filter_handler = () ->
  filters = $('.filters')
  url = '/'+filters.attr('id')
  xhr = null

  search_preset = window.location.hash.replace('#','')

  filters.on 'changed', ->
    list_block =  $('.list')

    if (xhr != null)
      xhr.abort()

    list_block.addClass('filled')

    History.pushState({}, null, url+'?'+decodeURIComponent($.param(filters.prepare_params())))
    xhr = $.ajax
      url: url
      type: 'GET'
      data: filters.prepare_params()
      success: (data, textStatus, jqXHR) ->
        list_block.html(jqXHR.responseText)
        init_tablesorter()
        init_remote_pagination()

  if search_preset.length && filters.length

    if search_preset == 'todays'
      hour = new Date().getHours()
      $('#by_date').customslider('values', 0, 0)
      $('#by_date').customslider('values', 1, 1)
      $('#by_time').customslider('values', [hour, 24])
      $('.by_time h6 a').click()
      filters.trigger('changed')
      return false

    if search_preset.length
      $('h6 a', $('.' + search_preset).closest('.filter')).click()
      $('.' + search_preset).click()
      return false
