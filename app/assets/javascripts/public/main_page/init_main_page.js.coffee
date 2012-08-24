@init_main_page = () ->

  prepare_affiche_list()

  $('.main_page_affiche .today_in_city_menu ul li a').live 'click', (event) ->
    link = $(this)
    url = link.attr('href')
    $.ajax
      url: url
      success: (data, textStatus, jqXHR) ->
        $('.main_page_affiche .affiche').animate
          opacity: 0
        , 100, ->
          $('.main_page_affiche').replaceWith(data)
          $('.main_page_affiche .affiche').css
            opacity: 0
          .animate
            opacity: 1
          , 300
          prepare_affiche_list()
      error: (jqXHR, textStatus, errorThrown) ->
        alert jqXHR
    false

  $('.main_page_affiche .was_in_city li').each ->
    li_block = $(this)
    images_block = $('.relative', this)
    $('img', li_block).each ->
      offset_x = images_block.outerWidth(true,true) / 2 - $(this).outerWidth(true, true) / 2
      offset_y = images_block.outerHeight(true,true) / 2 - $(this).outerHeight(true, true) / 2
      $(this).css
        left: randomize(offset_x)
        top: randomize(offset_y)

  $('.main_page_affiche .was_in_city li img').hover ->
    $('img', $(this).closest('li')).css
      'z-index': 0
    , 200
    $(this).css
      'z-index': 1
    , 100

prepare_affiche_list = ->

  list = $('.main_page_affiche .affiche ul')

  if $('li', list).length < 5
    list_height = 0
    $('li', list).each ->
      list_height = $(this).outerHeight(true, true) if  list_height < $(this).outerHeight(true, true)
    list.closest('.affiche')
      .width($('li', list).outerWidth(true, true) * $('li', list).length)
      .height(list_height)

  list_width = 0
  $('li', list).each ->
    list_width += $(this).outerWidth(true, true)
  list.width(list_width)

  if $('li', list).length
    $('.main_page_affiche .affiche').jScrollPane
      showArrows: true

  true

randomize = (number) ->
  Math.floor(Math.random() * Math.round(number) + 1)
