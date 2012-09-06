# Global Scope
root = exports ? this

class gc.Canvas
	constructor: ->
		# For now, initialize a new poly. Later allow loading.
		@poly = gc.Polygon.find 3

		# Initialize the UI Handlers
		this.initHandlers()

	initHandlers: ->
		# Add a vertex to the poly when a user clicks on the map
		google.maps.event.addListener gc.map, "click", (event) =>
			@poly.newVertex event.latLng

		# Reset the poly if a user clicks the reset button
		$('button#reset_poly').click (event) =>
			event.preventDefault()
			@poly.reset()