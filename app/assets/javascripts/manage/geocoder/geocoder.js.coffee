$.fn.get_object = ->
  form_data = this.serializeArray()
  form_object = {}
  $(form_data).each (i, item) ->
    form_object[item.name] = item.value
  form_object

$.fn.draw_map = (organization, context) ->
  container = this[0]
  point = new DG.GeoPoint(organization[context+'[address_attributes][longitude]'], organization[context+'[address_attributes][latitude]'])
  map = new DG.Map(container)
  marker = new DG.Markers.Common({ geoPoint: point })
  scale = organization['scale'] || 15
  DG.autoload ->
    map.controls.add(new DG.Controls.Zoom())
  map.setCenter(point, scale)
  map.markers.add(marker)

update_coordinates = (organization, context) ->
  $.ajax '/geocoder',
    async:    false
    dataType: 'json'
    data:     'street='+organization[context+'[address_attributes][street]']+'&house='+organization[context+'[address_attributes][house]']
    error: (jqXHR, textStatus, errorThrown) ->
      console.log(errorThrown)

    success: (data, textStatus, jqXHR) ->
      json = jQuery.parseJSON jqXHR.responseText
      organization[context+'[address_attributes][longitude]'] = json.longitude
      organization[context+'[address_attributes][latitude]']  = json.latitude
      organization['scale'] = json.scale
      $('#'+context+'_address_attributes_longitude').val(json.longitude)
      $('#'+context+'_address_attributes_latitude').val(json.latitude)

$.fn.handler = (form, map_container, context) ->
  this.click ->
    organization = form.get_object()
    update_coordinates(organization, context)
    map_container.draw_map(organization, context)
    false

$ ->
  form = $('form.simple_form')
  if form.length
    organization = form.get_object()
    map_container = $('#map')
    context = form.attr('id').replace(/(new|edit)_/, '').replace(/_\d+/, '')
    update_coordinates(organization, context)
    map_container.draw_map(organization, context)
    $('.get_coordinates').handler(form, map_container, context)
