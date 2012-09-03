# Global Scope
root = exports ? this

class gc.Canvas
	constructor: ->
		# Manually test drawing a polygon
		this.loadPoly()

		# Add a listener for the click event
		google.maps.event.addListener gc.map, "click", (event) ->
			alert event.latLng

	loadPoly: ->
		# Test loading coordinates from the server and drawing a poly.
		self = this
		$.ajax
			url: $('div#map_canvas').data('polygons-url')
			dataType: 'json'
			success: (data, textStatus, jqHXR) ->
				poly = new gc.Polygon( data )
				poly.draw()

###
Note: The direction this is going, it would probably be best
if this "Canvas" became the thing we think of as a user's
drawing space. Ie. A user can have multiple canvases, and when
they start drawing they can either be on a new canvas, or open
an old one. That means the functionality in this constructor should
probably move to the global geoCANVAS (gc) init method,
while the loadPoly method is only for temporary testing anyway.
###