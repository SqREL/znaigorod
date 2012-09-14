@init_filters_toggler = () ->

  $(".need_toggler").need_toggler()

$.fn.need_toggler = () ->

  $(this).each (index, item) ->

    list = $(item)

    VISIBLE_LINES_COUNT = 5

    OPENED_HEIGHT = list.height() - parseInt(list.css("padding-bottom"))
    iterator = -1
    top = 0
    $("li", list).each (index, item) ->
      if top < $(item).position().top
        top = $(item).position().top
        iterator += 1
      $(item).attr("data-line", "line-#{iterator}")
      return true

    list.wrap("<div class='toggable' />")
    toggable = list.closest(".toggable")
    list_title = $("li:first", list).text().toLowerCase()
    $("<div class='toggler'><a href='#'><span>Все #{list_title}</span></a></div>").appendTo(toggable).hide()
    toggle_link = $(".toggler a", toggable)

    if parseInt($("li:last", list).attr('data-line').replace('line-', '')) > VISIBLE_LINES_COUNT
      toggle_link.closest(".toggler").show()

      last_visible_element = $("li[data-line=line-#{VISIBLE_LINES_COUNT}]:first", list)
      if $("li.selected", list).length && parseInt($("li.selected:last", list).attr('data-line').replace('line-', '')) > VISIBLE_LINES_COUNT
        last_visible_element = $("li.selected:last", list)

      CLOSED_HEIGHT = last_visible_element.position().top

      list.height(CLOSED_HEIGHT)

      toggle_link.addClass("close")

      toggle_link.removeClass("close") if parseInt(last_visible_element.attr('data-line').replace('line-', '')) == iterator

    toggle_link.click (event) ->
      return false unless $(this).hasClass("open") || $(this).hasClass("close")
      $(this).toggle_arrow()
      list.animate
        height: if $(this).hasClass("open") then OPENED_HEIGHT else CLOSED_HEIGHT
      , 500, 'easeOutQuint'
      return false

    return true

  # helpers

  $.fn.toggle_arrow = () ->
    $(this).toggleClass("open")
    $(this).toggleClass("close")
    return true

  return true
