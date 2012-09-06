$ ->
  init_common()
  init_main_page() if $('.main_page_affiche').length
  init_affiches_filter() if $('.affiches_filter .periods .daily').length
  init_affiches_map() if $('.affiches_list .info .place .address a').length
  true
