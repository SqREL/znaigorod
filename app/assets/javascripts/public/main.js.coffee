$ ->
  init_common()
  init_main_page() if $('.main_page_affiche').length
  init_affiches_filter() if $('.affiches_filter .periods .daily').length
  init_affiches_map() if $('.show_map_link').length
  init_tabs() if $('.content .tabs').length
  init_poster() if $('.content .tabs .image img').length
  init_distribution() if $('.content .distribution').length
  init_galleria() if $('.content .gallery_container').length
  init_filters_toggler() if $('.need_toggler li').length
  true
