@init_prepare_organizations = () ->
  $(".organizations_list .info .characteristics ul").each (index, list) ->
    top = 0
    $('li', list).each (index, item) ->
      if top < $(item).position().top
        $(item).addClass('offset_left') if top > 0
        top = $(item).position().top
