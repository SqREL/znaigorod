$ ->
  init_history()              if $('.filters').length
  init_main_page_banner()     if $('.main_page_block').length
  init_seance_tabs()          if $('.seance_tabs').length
  init_tablesorter()          if $('.sortable').length
  init_remote_pagination()    if $('.pagination').length

  if ('.filter').length
    init_filter_collapser()
    init_filter_reset()
    init_filter_resizer()       if $('.filter.by_date').length
    init_filter_checker()       if $('.filter.by_affiche_category, .filter.by_category, .filter.by_tag').length
    init_range_slider()         if $('.filter.by_date').length
    init_filter_handler()
    init_map_handler()

  true
