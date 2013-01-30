@init_loading_items = () ->

  return true unless $('body > nav.pagination').length

  $('body > nav.pagination').css
    'height': '0'
    'visibility': 'hidden'
  list_url = window.location.pathname
  list = $(
    '.content_wrapper .affiches_list ul.items_list,' +
    '.content_wrapper .affiches_list ul.was_in_city_photos,' +
    '.content_wrapper .organizations_list ul.items_list,' +
    '.content_wrapper .search_results ul.items_list'
  )
  first_item = $('li:first', list)
  return true unless first_item.length
  if first_item.siblings().length
    last_item = first_item.siblings().last()
  else
    last_item = first_item
  last_item_top = last_item.position().top
  page = 1
  busy = false
  $(window).scroll ->
    if $(this).scrollTop() + $(this).height() >= last_item_top && !busy
      busy = true
      search_params = ""
      if window.location.search.match(/(\?|&)q=/) && window.location.search.match(/(\?|&)utf8=/)
        search_params = window.location.search.replace(/^\?/, "&").replace(/&page=\d+/, "")
      $.ajax
        url: "#{list_url}?page=#{parseInt(page) + 1}#{search_params}"
        beforeSend: (jqXHR, settings) ->
          $('<li class="ajax_loading_items_indicator">&nbsp;</li>').appendTo(list)
          true
        complete: (jqXHR, textStatus) ->
          $('li.ajax_loading_items_indicator', list).remove()
          true
        success: (data, textStatus, jqXHR) ->
          return true if data.match(/empty_items_list/)
          list.append(data)
          last_item = first_item.siblings().last()
          last_item_top = last_item.position().top
          page += 1
          busy = false if data.length
          init_photogallery() if $('.content_wrapper .was_in_city_photos li').length && data.length
          true
        error: (jqXHR, textStatus, errorThrown) ->
          console.log jqXHR.responseText.strip_tags() if console && console.log
          true
    true
  true
