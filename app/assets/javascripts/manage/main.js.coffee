handle_adding_poster = ->
  $('.choose_file').live('click', ->
    link = $(this)
    params = $(this).attr('params')
    attached_file_wrapper = link.parent()
    origin_id = attached_file_wrapper.find('input').attr('id')
    input = $('#'+origin_id)

    dialog = link.create_or_return_dialog('elfinder_picture_dialog')

    dialog.attr('id_data', origin_id)

    dialog.load_iframe(params)

    input.change ->
      image_url = input.val()
      file_name = decodeURIComponent(image_url).match(/([^\/.]+)(\.(.{3}))?$/)
      attached_file_wrapper.children('.image_wrapper').html('<a href="'+image_url+'"><img src="'+image_url.replace(new RegExp(/\d+-\d+/), '150-150')+'" width="150" ></a>')
      input.unbind('change')

    false
  )

$ ->
  init_noisy()
  init_new_affiche()
  handle_adding_poster()
  init_datetime_picker()
  init_red_cloth()
  init_autosuggest_handler() if $('.autosuggest').length
  init_choose_coordinate() if $('.choose_coordinate').length
  #init_jwysiwyg() if $('textarea').length
