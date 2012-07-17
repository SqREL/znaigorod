@init_new_affiche = () ->
  link = $('.dropdown')
  ul = link.next('ul')
  link.click ->
    ul.toggle()
    link.toggleClass('show')
    false
