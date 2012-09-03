# Global Scope
root = exports ? this

class gc.Polygon
	constructor: (@id, @points) ->
		@coords = ( new google.maps.LatLng(point[0], point[1]) for point in @points )

	draw: (options) ->
		defaults =
			strokeColor: '#000000'
			strokeOpacity: 1.0
			strokeWeight: 3

		# Use defaults unless options given by user.
		config = $.extend defaults, options

		poly = new google.maps.Polyline(config)
		poly.setMap(gc.map)
		path = poly.getPath()
		path.push(coord) for coord in @coords

	area: ->
		null


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