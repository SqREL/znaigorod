$ ->
  init_common()
  init_main_page() if $('.main_page_affiche').length
  init_affiches_filter() if $('.affiches_filter .periods .daily').length
  init_affiches_map() if $('.show_map_link').length
  init_tabs() if $('.content .tabs').length
  init_poster() if $('.content .tabs .image img').length
  true
