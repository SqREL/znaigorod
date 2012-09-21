@init_photogallery = () ->
  $('.content_wrapper .was_in_city_photos li').each ->
    li_block = $(this)
    images_block = $('.relative', this)
    $('img', li_block).each (index) ->
      img_width = $(this).outerWidth(true, true)
      img_height = $(this).outerHeight(true, true)
      offset_x = images_block.outerWidth(true,true) / 2 - img_width / 2
      offset_y = images_block.outerHeight(true,true) / 2 - img_height / 2
      switch index
        when 0
          angle = "-12deg"
          offset_x = offset_x - 5
        when 1
          angle = "-5deg"
          offset_x = offset_x - 2
        when 2
          angle = "5deg"
          offset_x = offset_x + 2
        when 3
          angle = "12deg"
          offset_x = offset_x + 5
      $(this).css
        "left": offset_x
        "top": offset_y
        "-webkit-transform": "rotate(#{angle})"
        "-moz-transform": "rotate(#{angle})"
        "-ms-transform": "rotate(#{angle})"
        "-o-transform": "rotate(#{angle})"
        "transform": "rotate(#{angle})"
      $(this).load ->
        img_width = $(this).width()
        img_height = $(this).height()
        offset_x = images_block.outerWidth(true,true) / 2 - img_width / 2
        offset_y = images_block.outerHeight(true,true) / 2 - img_height / 2
        switch index
          when 0
            angle = "-12deg"
            offset_x = offset_x - 5
          when 1
            angle = "-5deg"
            offset_x = offset_x - 2
          when 2
            angle = "5deg"
            offset_x = offset_x + 2
          when 3
            angle = "12deg"
            offset_x = offset_x + 5
        $(this).css
          "left": offset_x
          "top": offset_y
          "-webkit-transform": "rotate(#{angle})"
          "-moz-transform": "rotate(#{angle})"
          "-ms-transform": "rotate(#{angle})"
          "-o-transform": "rotate(#{angle})"
          "transform": "rotate(#{angle})"

