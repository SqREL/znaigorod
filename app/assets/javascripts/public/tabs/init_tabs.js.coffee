@init_tabs = () ->

  window.scrollTo(0, 0) if window.location.hash

  container = $(".content .tabs")

  container.tabs
    disabled: get_disabled()
    show: (event, ui) ->
      window.location.hash = $(ui.tab).attr('href')
      window.scrollTo(0, 0)
      prepare_borders(ui)
      link = $(ui.tab).attr('data-link')
      if link && !$(ui.panel).html().trim()
        $.ajax
          url: link
          beforeSend: (jqXHR, settings) ->
            $(ui.panel).html("<p class='ajax_loading'>Загрузка...</p>")
            true
          success: (data, textStatus, jqXHR) ->
            $(ui.panel).html(data)
            init_galleria() if data.match /gallery_container/g
            init_swfkrpano() if data.match /krpano/g
            true
          error: (jqXHR, textStatus, errorThrown) ->
            $(ui.panel).html("<p class='error'>Ошибка!</p>")
            true

prepare_borders = (ui) ->
  $("li", $(ui.tab).closest("ul")).each (index, item) ->
    $(this).css
      "border-right": "1px solid #d2cfd8"
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
