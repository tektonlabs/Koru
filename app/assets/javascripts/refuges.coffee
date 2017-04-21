@loadMapWithLocations = (locations) ->
  lima =
    lat: -12.0431800
    lng: -77.0282400
  map = new (google.maps.Map)(document.getElementById('refuges-map'),
    zoom: 12
    center: lima)
  locations = locations
  infowindow = new (google.maps.InfoWindow)
  markers = []
  for location in locations
    marker = new (google.maps.Marker)(
      position: new (google.maps.LatLng)(location[1], location[2])
      content: location[0]
      map: map)
    markers.push marker
    google.maps.event.addListener marker, 'mouseover', do (marker) ->
      ->
        infowindow.setContent marker.content
        infowindow.open map, marker
        return
    google.maps.event.addListener marker, 'mouseout', ((marker) ->
      ->
        infowindow.close()
        return
    )()
  bounds = new (google.maps.LatLngBounds)
  j = 0
  while j < markers.length
    bounds.extend markers[j].getPosition()
    j++
  map.fitBounds bounds

  # Search for google maps
  input = document.getElementById('input-search')
  searchBox = new (google.maps.places.SearchBox)(input)
  map.addListener 'bounds_changed', ->
    searchBox.setBounds map.getBounds()
    return
  new_markers = []
  searchBox.addListener 'places_changed', ->
    places = searchBox.getPlaces()
    console.log places
    if places.length == 0
      return
    new_markers.forEach (marker) ->
      marker.setMap null
      return
    new_markers = []
    new_bounds = new (google.maps.LatLngBounds)
    places.forEach (place) ->
      if !place.geometry
        console.log 'Returned place contains no geometry'
        return
      icon =
        url: place.icon
        size: new (google.maps.Size)(71, 71)
        origin: new (google.maps.Point)(0, 0)
        anchor: new (google.maps.Point)(17, 34)
        scaledSize: new (google.maps.Size)(25, 25)
      new_markers.push new (google.maps.Marker)(
        map: map
        icon: icon
        title: place.name
        position: place.geometry.location)
      if place.geometry.viewport
        new_bounds.union place.geometry.viewport
      else
        new_bounds.extend place.geometry.location
      return
    map.fitBounds new_bounds
    return
  return



@initialize_refuges = ->
  $('#refuges-map').css('height', $('#sidebar-nav').height())

$(document).ready ->
  initialize_refuges()
  $("#search-button").on 'click', ->
    input = document.getElementById('input-search')
    google.maps.event.trigger input, 'focus'
    google.maps.event.trigger input, 'keydown', keyCode: 13
    return
