# Global Scope
root = exports ? this

class gc.Polygon
	constructor: (@id, points, polyOptions, markerOptions) ->
		@coords = []
		@markers = new google.maps.MVCArray()

		# Set Poly and Marker Options
		this.setPolyOptions polyOptions
		this.setMarkerOptions markerOptions

		# Setup the poly and path
		@poly = new google.maps.Polyline @polyOptions
		@poly.setMap(gc.map)
		@path = @poly.getPath()

		# Pre-assign coordinates for the Poly
		if points?
			for point in points
				latLng = new google.maps.LatLng point[0], point[1]
				this.newVertex latLng

	setPolyOptions: (options) ->
		defaults = 
			strokeColor: '#FF0000'
			strokeOpacity: 1.0
			strokeWeight: 3
			fillColor: '#FF0000'
			fillOpacity: 0.5
		@polyOptions = $.extend defaults, options

	setMarkerOptions: (options) ->
		defaults =
			map: gc.map
			draggable: true
			raiseOnDrag: false
			title: "Drag me to change shape"
			icon: new google.maps.MarkerImage("marker.png", new google.maps.Size(9, 9), new google.maps.Point(0, 0), new google.maps.Point(5, 5))
		@markerOptions = $.extend defaults, options

	reset: ->
		@path.clear()
		@markers.forEach (marker) -> # CoffeeScript for ... in doesn't work on MVC arrays for some reason.
			marker.setMap(null)
		@markers.clear()
		gc.display.clear()

	# MANIPULATION METHODS ------------------------ #

	newMarker: (latLng) ->
		# Merge latLng into the given marker options
		config = @markerOptions
		config.position = latLng

		# Return a marker object
		marker = new google.maps.Marker config
	
	newVertex: (latLng) ->
		# Add this LatLng to our polygon path
		# Objects added to these MVCArrays automatically update the line and polygon shapes on the map
		@path.push(latLng)

		# Add a marker where the user clicked
		marker = this.newMarker latLng
		@markers.push(marker)

		# Get the index position of the LatLng we just pushed into the MVCArray
		# We'll need this later to update the MVCArray if the user moves the measure vertexes
		latLngIndex = @path.getLength() - 1

		# If the path has more than one point, update the display
		if @path.getLength() > 1
			gc.display.object this

		# When the user mouses over the measure vertex markers, change shape and color to make it obvious they can be moved
		google.maps.event.addListener marker, "mouseover", ->
			marker.setIcon new google.maps.MarkerImage "hovermarker.png", new google.maps.Size(15, 15), new google.maps.Point(0, 0), new google.maps.Point(8, 8)

		# Change back to the default marker when the user mouses out
		google.maps.event.addListener marker, "mouseout", ->
			marker.setIcon new google.maps.MarkerImage "marker.png", new google.maps.Size(9, 9), new google.maps.Point(0, 0), new google.maps.Point(5, 5)

		# When the measure vertex markers are dragged, update the geometry of the line and polygon by resetting the
		# LatLng at this position
		google.maps.event.addListener marker, "drag", (event) =>
			@path.setAt latLngIndex, event.latLng

		# When dragging has ended and there is more than one vertext, update the displays.
		google.maps.event.addListener marker, "dragend", =>
			if @path.getLength() > 1
				gc.display.object this
	

	# COMPUTATION METHODS ------------------------ #

	# Compute area of polygon
	area: ->
		if @path.getLength() > 2
			area = google.maps.geometry.spherical.computeArea @path 
		else
			0

	# Compute length of polygon perimeter
	length: ->
		length = google.maps.geometry.spherical.computeLength @path

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