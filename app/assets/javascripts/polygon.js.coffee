# Global Scope
root = exports ? this

gc.polygon = (map, points) ->
	@points = points
	@map = map
	@coords = []
	this.initialize()

gc.polygon.prototype = 
	initialize: ->
		@coords.push( new google.maps.LatLng point[0], point[1] ) for point in @points
		return this

	defaultOptions:
		strokeColor: '#000000'
		strokeOpacity: 1.0
		strokeWeight: 3

	draw: ->
		poly = new google.maps.Polyline(@defaultOptions)
		poly.setMap(@map)
		path = poly.getPath()
		path.push(coord) for coord in @coords