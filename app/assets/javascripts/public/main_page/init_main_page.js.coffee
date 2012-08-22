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

  $('.main_page_affiche affiche a.disabled').live 'click', (event) ->
    false

prepare_affiche_list = ->
  list = $('.main_page_affiche .affiche ul')

  if $('li', list).length < 5
    $('.main_page_affiche a.prev').hide()
    $('.main_page_affiche a.next').hide()
    list.closest('.affiche').width($('li', list).outerWidth(true, true) * $('li', list).length)

  list.width($('li', list).outerWidth(true, true) * $('li', list).length)
