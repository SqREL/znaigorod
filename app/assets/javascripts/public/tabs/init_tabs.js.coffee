@init_tabs = () ->

  window.scrollTo(0, 0) if window.location.hash

  container = $(".content .tabs")

  $('.info .description table tr', container).each (index, item) ->
    td = $('td:first', this)
    td.text(td.text() + ':')
    true

  container.tabs
    cache: true
    disabled: get_disabled()
    ajaxOptions:
      success: (xhr, status, index, anchor) ->
        init_galleria() if xhr.match /gallery_container/g
    show: (event, ui) ->
      prepare_borders(ui)
    select: (event, ui) ->
      prepare_borders(ui)

prepare_borders = (ui) ->
  $(ui.tab).closest("li").prev("li").css
    "border-right": "none"
  $(ui.tab).closest("li").css
    "border-right": "1px solid #d2cfd8"
  true

get_disabled = () ->
  disabled_array = []
  $(".content .tabs .nav li").each (index, item) ->
    disabled_array.push(index) if $(item).hasClass("disabled")
  disabled_array
