@init_iconize_info = () ->
  block = $('.organization_info .iconize_info')
  block.each (index, item) ->
    block_item = $(item)
    $('a', block_item).click (event) ->
      if  block_item.next('h1').length
        title = block_item.next('h1').html()
      else
        title = block_item.next('span').text()

      data = "<h1>#{title}</h1>"
      if $(this).attr('data-link') == 'description_text'
        box_width = '700px'
        box_height = 'auto'
        data += $('.description_text', block_item).html()

      if $(this).attr('data-link') == 'service_text'
        box_width = '500px'
        box_height = 'auto'
        data += $('.description_text', block_item).html()

      if $(this).attr('data-link') == 'tour_link'
        box_width = '790px'
        box_height = '760px'
        data += "
          <div id='krpano'>
            <noscript><center>ERROR: Javascript not activated</center></noscript>
            <a href='#{$('.tour_link', block_item).text()}' class='tour_link'>#{$('.tour_link', block_item).text()}</a>
          </div>
          <div class='ad'>
            <a href='http://tomsk.3dtour.me/' class='3dtourme' rel='nofollow' target='_blank'>
              <img alt='Изготовление и размещение виртуальных туров' height='69' src='/assets/public/3dtour.png' width='740' />
            </a>
          </div>"
      $.colorbox
        width: box_width
        height: box_height
        html: data
        onComplete: () ->
          init_swfkrpano()
          true
      false
  true
