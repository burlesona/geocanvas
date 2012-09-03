# Global Scope
root = exports ? this

class gc.Canvas
	# Test loading a poly from server and draw it.
	testDraw: ->
		poly = gc.Polygon.find(1)
		poly.draw strokeColor: '#FF0000', strokeWeight: 1

###
NOTE:
	Future direction of this module should be to allow the
	User to have_many Canvases, which have_many Polygons.
###