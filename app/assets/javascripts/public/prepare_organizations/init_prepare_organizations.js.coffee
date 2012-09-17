@init_prepare_organizations = () ->
  $(".organizations_list .info .characteristics ul").each (index, list) ->
    top = 0
    left = $("li:first", list).next().position().left
    $('li', list).each (index, item) ->
      if top < $(item).position().top
        top = $(item).position().top
        if top > 0
          $(item).addClass('offset_left').css
            "margin-left": left
