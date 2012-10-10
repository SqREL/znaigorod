$ ->
  init_common()
  init_vk_like() if $('#vk_like').length
  init_vk_recommended() if $('#vk_recommended').length
  init_vk_comments() if $('#vk_comments').length
  init_vk_group_thin() if $('#vk_group_thin').length
  init_vk_group_thick() if $('#vk_group_thick').length
  init_vk_group_news() if $('#vk_group_news').length
  init_vk_group_subscribers() if $('#vk_group_subscribers').length
  init_main_page() if $('.main_page_affiche').length
  init_affiches_filter() if $('.affiches_filter .periods .daily').length
  init_affiches_map() if $('.show_map_link').length
  init_tabs() if $('.content .tabs').length
  init_poster() if $('.content .tabs .image img').length
  init_distribution() if $('.content .distribution').length
  init_galleria() if $('.content .gallery_container').length
  init_filters_toggler() if $('.need_toggler li').length
  init_prepare_organizations() if $('.organizations_list .info .characteristics').length
  init_photogallery() if $('.content_wrapper .was_in_city_photos li').length
  init_loading_items() if $('.content_wrapper .affiches_list ul li, .content_wrapper .organizations_list ul li').length
  init_list_settings() if $('.content_wrapper .list_settings').length
  init_swfkrpano() if $("#krpano").length
  true
