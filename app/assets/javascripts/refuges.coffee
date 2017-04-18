@loadMapWithLocations = (locations) ->
  handler = Gmaps.build('Google')
  handler.buildMap { internal: id: 'multi_markers' }, ->
    markers = handler.addMarkers(locations)
    handler.bounds.extendWith markers
    handler.fitMapToBounds()
    return
  return

@initialize_refuges = ->
  $('#refuges-map').css('height', $('#sidebar-nav').height() - 56)

$(document).ready ->
  initialize_refuges()
