@init_new_affiche = () ->
  link = $('.dropdown')
  link.click ->
    link.next('ul').toggle()
    link.toggleClass('show')
    false
