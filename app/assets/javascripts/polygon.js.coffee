# Global Scope
root = exports ? this

class gc.Polygon
	constructor: (@id, @points) ->
		@coords = ( new google.maps.LatLng(point[0], point[1]) for point in @points )
		@poly = null
	
	draw: (options) ->
		# Use defaults unless options given by user.
		defaults =
			strokeColor: '#000000'
			strokeOpacity: 1.0
			strokeWeight: 3
		config = $.extend defaults, options

		# Draw the poly
		@poly = new google.maps.Polyline(config)
		@poly.setMap(gc.map)
		path = @poly.getPath()
		path.push(coord) for coord in @coords

		# Update the information displays
		gc.display.object this

	# Compute area of polygon
	area: ->
		path = @poly.getPath()
		area = google.maps.geometry.spherical.computeArea path if path.getLength() > 2

	# Compute length of polygon perimeter
	length: ->
		length = google.maps.geometry.spherical.computeLength @poly.getPath()


	# CLASS METHODS ------------------------------ #
	@find: (id) ->
		poly = null;
		$.ajax
			async: false
			url: gc.routes.polygon_url(id)
			dataType: 'json'
			success: (data, textStatus, jqHXR) ->
				poly = new gc.Polygon data.id, data.points
		return poly