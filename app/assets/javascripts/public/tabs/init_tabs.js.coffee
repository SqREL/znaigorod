@init_tabs = () ->
  container = $(".content .tabs")
  container.tabs
    disabled: get_disabled()
    show: (event, ui) ->
      prepare_borders(ui)
    select: (event, ui) ->
      prepare_borders(ui)
    cookie:
      expires: 30

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
