# Global Scope
root = exports ? this

jQuery ->
	new GeoCanvas $('div#map_canvas')

root.GeoCanvas = (canvas) ->
	@canvas = $(canvas)[0]
	this.initialize()

root.GeoCanvas.prototype =
	initialize: ->
		houston = new google.maps.LatLng(29.75, -95.40)
		options =
			zoom: 14
			center: houston
			mapTypeId: google.maps.MapTypeId.ROADMAP
			draggableCursor: "crosshair"

		map = new google.maps.Map @canvas, options

		polyOptions =
			strokeColor: '#000000'
			strokeOpacity: 1.0
			strokeWeight: 3

		poly = new google.maps.Polyline(polyOptions)
		poly.setMap(map)

		coords = [
			new google.maps.LatLng(29.74, -95.40)
			new google.maps.LatLng(29.74, -95.41)
			new google.maps.LatLng(29.75, -95.41)
			new google.maps.LatLng(29.75, -95.40)
			new google.maps.LatLng(29.74, -95.40)
		]

		# TEST Pre-Load a Poly
		path = poly.getPath()
		path.push(point) for point in coords

		# Add a listener for the click event
		google.maps.event.addListener map, "click", (event) ->
			alert event.latLng