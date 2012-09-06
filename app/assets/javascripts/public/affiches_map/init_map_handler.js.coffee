@init_affiches_map = () ->
  container = $('<div class="map_container" />').appendTo('body').hide()
  $('.affiches_list .info .place .address a').live 'click', ->
    link = $(this)
    longitude = link.attr('longitude')
    latitude = link.attr('latitude')
    map = container.dialog(
      modal: true
      height: 480
      resizable: false
      title: link.prev('.address').html()
      width: 640
      zIndex: 700
      close: ->
        map.destroy()
        map = null
    ).draw_map(longitude, latitude)

    false

$.fn.draw_map = (longitude, latitude, scale = 16) ->
  container = this[0]
  point = new DG.GeoPoint(longitude, latitude)
  map = new DG.Map(container)
  marker = new DG.Markers.Common({ geoPoint: point })
  map.controls.add(new DG.Controls.Zoom())
  map.setCenter(point, scale)
  map.markers.add(marker)
  return map

