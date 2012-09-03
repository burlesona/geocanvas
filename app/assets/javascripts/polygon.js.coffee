# Global Scope
root = exports ? this

class gc.Polygon
	constructor: (@points) ->
		@coords = ( new google.maps.LatLng(point[0], point[1]) for point in @points )

	defaultOptions:
		strokeColor: '#000000'
		strokeOpacity: 1.0
		strokeWeight: 3

	draw: ->
		poly = new google.maps.Polyline(@defaultOptions)
		poly.setMap(gc.map)
		path = poly.getPath()
		path.push(coord) for coord in @coords