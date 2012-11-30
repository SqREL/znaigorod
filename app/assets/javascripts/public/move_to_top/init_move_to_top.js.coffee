@init_move_to_top = () ->
  link = $("a.move_to_top")

  barrier = link.prev("div").outerHeight(true, true) + 100

  link.css
    top: $(window).height() / 2 - link.outerHeight() / 2
    left: link.prev().position().left + link.prev().outerWidth() / 2 - link.outerWidth() / 2 + 20

  $(window).resize ->
    link.css
      top: $(window).height() / 2 - link.outerHeight() / 2
      left: link.prev().position().left + link.prev().outerWidth() / 2 - link.outerWidth() / 2 + 20

  $(window).scroll ->
    if link.is(":hidden") && $(this).scrollTop() > barrier
      link.fadeTo('fast', 0.5)
    if link.is(":visible") && $(this).scrollTop() < barrier
      link.fadeOut('fast')

  link.hover ->
    $(this).css
      opacity: 1
    true
  , ->
    $(this).css
      opacity: 0.5
    true

  link.click (event) ->
    window.scrollTo(0, 0)
    false

  true
