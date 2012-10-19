$ ->
  init_noisy() if $('body').hasClass('noisy')
  init_new_affiche() if $('.dropdown').length
  init_choose_file() if $('.choose_file').length
  init_datetime_picker()
  init_autosuggest_handler() if $('.autosuggest').length
  init_choose_coordinate() if $('.choose_coordinate').length
  init_vk_token() if $('.form_view.vk_token').length
