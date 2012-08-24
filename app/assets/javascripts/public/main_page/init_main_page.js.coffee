@init_main_page = () ->

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

  prepare_affiche_list()

prepare_affiche_list = ->

  list = $('.main_page_affiche .affiche ul')

  if $('li', list).length < 5
    list.closest('.affiche').width($('li', list).outerWidth(true, true) * $('li', list).length)

  list_width = 0
  $('li', list).each (index, item) ->
    list_width += $(item).outerWidth(true, true)
  list.width(list_width)

  $('.main_page_affiche .affiche')
    .width($('li:first', list).outerWidth(true, true) * 4)
    .jScrollPane
      trackClickSpeed: 150
      arrowScrollOnHover: true

  true
