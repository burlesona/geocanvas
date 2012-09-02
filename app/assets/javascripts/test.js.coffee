# Global Scope
root = exports ? this

jQuery ->
	new GeoCanvas $('div#map_canvas')

root.GeoCanvas = (canvas) ->
	@canvas = $(canvas)[0]
	@map = null
	this.initialize()

root.GeoCanvas.prototype =
	initialize: ->
		houston = new google.maps.LatLng(29.75, -95.40)
		options =
			zoom: 14
			center: houston
			mapTypeId: google.maps.MapTypeId.ROADMAP
			draggableCursor: "crosshair"

		@map = new google.maps.Map @canvas, options

		this.drawPoly()

		# Add a listener for the click event
		google.maps.event.addListener @map, "click", (event) ->
			alert event.latLng

	drawPoly: ->
		polyOptions =
			strokeColor: '#000000'
			strokeOpacity: 1.0
			strokeWeight: 3

		poly = new google.maps.Polyline(polyOptions)
		poly.setMap(@map)

		response = null
		$.ajax
			async: false
			url: $('div#map_canvas').data('polygons-url')
			dataType: 'json'
			success: (data, textStatus, jqHXR) ->
				response = data

		coords = []
		for point in response
			coords.push( new google.maps.LatLng point[0], point[1] )

		# TEST Pre-Load a Poly
		path = poly.getPath()
		path.push(coord) for coord in coords