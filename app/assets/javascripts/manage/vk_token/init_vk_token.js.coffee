@init_vk_token = () ->
  $('#vk_token_token').val window.location.hash.match(/#access_token=(\w+)/)[1]
  $('#vk_token_expires_in').val window.location.hash.match(/.*expires_in=(\d+)/)[1]
  $('button').click()
