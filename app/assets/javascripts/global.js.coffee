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

		# Make a geocoder available for searching and set search form
		@geocoder = new google.maps.Geocoder()
		$('form#location_search').submit (event) =>
			event.preventDefault()
			@search $('input#lstring').val()

		# Add a listener for the click event
		google.maps.event.addListener @map, "click", (event) ->
			alert event.latLng

		# Test drawing a poly
		canvas = new gc.Canvas;
		canvas.testDraw();

	setRoutes: ->
		@routes =
			polygons_url: $(@container).data('polygons-url')
			polygon_url: (id) ->
				this.polygons_url + "/" + id

	search: (string) ->
		console.log string
		@geocoder.geocode {address: string}, (results, status) =>
			if status == google.maps.GeocoderStatus.OK
				@map.setCenter results[0].geometry.location
				gc.display.location.lat results[0].geometry.location.lat()
				gc.display.location.lng results[0].geometry.location.lng()
			else
				alert status