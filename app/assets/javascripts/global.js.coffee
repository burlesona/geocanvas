# Global Scope
root = exports ? this

root.gc =
	version: 0.0

	init: (str) ->
		# Set gc.map for use throughout the app.
		@container = $(str)[0]
		houston = new google.maps.LatLng(29.75, -95.40)
		options =
			zoom: 14
			center: houston
			mapTypeId: google.maps.MapTypeId.ROADMAP
			draggableCursor: "crosshair"
		@map = new google.maps.Map @container, options

		# Setup routing data for the app
		this.setRoutes()

		# Add a listener for the click event
		google.maps.event.addListener this.map, "click", (event) ->
			alert event.latLng

		# Test drawing a poly
		canvas = new gc.Canvas;
		canvas.testDraw();

	setRoutes: ->
		@routes =
			polygons_url: $(@container).data('polygons-url')
			polygon_url: (id) ->
				this.polygons_url + "/" + id