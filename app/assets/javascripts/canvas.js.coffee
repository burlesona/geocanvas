# Global Scope
root = exports ? this

class gc.Canvas
	constructor: (canvas) ->
		@canvas = $(canvas)[0]

		houston = new google.maps.LatLng(29.75, -95.40)
		options =
			zoom: 14
			center: houston
			mapTypeId: google.maps.MapTypeId.ROADMAP
			draggableCursor: "crosshair"
		@map = new google.maps.Map @canvas, options

		# Manually test drawing a polygon
		this.drawPoly()

		# Add a listener for the click event
		google.maps.event.addListener @map, "click", (event) ->
			alert event.latLng

	drawPoly: ->
		# Test loading coordinates from the server and drawing a poly.
		self = this
		$.ajax
			url: $('div#map_canvas').data('polygons-url')
			dataType: 'json'
			success: (data, textStatus, jqHXR) ->
				poly = new gc.Polygon( self.map, data )
				poly.draw()
				console.log poly