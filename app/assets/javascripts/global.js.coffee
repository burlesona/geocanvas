# Global Scope
root = exports ? this

root.gc =
	version: 0.0
	init: (str) ->
		# Get the DOM element for the given string
		selector = $(str)[0]

		# Default options for base map.
		houston = new google.maps.LatLng(29.75, -95.40)
		options =
			zoom: 14
			center: houston
			mapTypeId: google.maps.MapTypeId.ROADMAP
			draggableCursor: "crosshair"

		# Sets gc.map for use throughout the app.
		this.map = new google.maps.Map selector, options
