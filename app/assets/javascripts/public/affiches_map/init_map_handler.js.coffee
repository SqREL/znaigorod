@init_affiches_map = () ->
  container = $('<div class="map_container" />').appendTo('body').hide()
  $('.show_map_link').live 'click', ->
    link = $(this)
    longitude = link.attr('longitude')
    latitude = link.attr('latitude')
    if longitude == '' || latitude == ''
      alert 'Не получится показать расположение объекта на карте\nКоординаты объекта не указаны или указаны не верно'
      return false
    map = container.dialog(
      height: 480
      resizable: false
      title: $('.name a', link.closest('p')).html()
      width: 640
      zIndex: 700
      close: ->
        map.destroy()
        map = null
    ).draw_map(longitude, latitude)

    return false

$.fn.draw_map = (longitude, latitude, scale = 16) ->
  container = this[0]
  point = new DG.GeoPoint(longitude, latitude)
  map = new DG.Map(container)
  marker = new DG.Markers.Common({ geoPoint: point })
  map.controls.add(new DG.Controls.Zoom())
  map.setCenter(point, scale)
  map.markers.add(marker)
  return map

