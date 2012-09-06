# Global Scope
root = exports ? this

gc.display =
	set: (attribute, value) ->
		value = gc.util.formatNumber(value) unless isNaN(value)
		selector = $("#" + attribute)
		
		# See if the element exists, then set value or text
		if selector.length
			if selector.is ':input'
				selector.val value
			else
				selector.text value
	
	clear: ->
		elements = $('#toolbar input:visible')
		$(e).val '' for e in elements


	# Automatically update the display with the attributes of an object
	object: (o) ->
		for own format of @area
			@area[format] o.area()
		for own format of @length
			@length[format] o.length()

	# Unit conversions for Length
	length:
		meters: (m) ->
			length = m
			gc.display.set 'length_m', length
		feet: (m) ->
			length = ( m * 3.28084 )
			gc.display.set 'length_ft', length
		miles: (m) ->
			length = ( m / 1609.34 )
			gc.display.set 'length_mi', length

	# Unit conversions for Area
	area:
		squareMeters: (m) ->
			area = m
			gc.display.set 'area_sqm', area
		squareFeet: (m) ->
			area = ( m * 10.7639 )
			gc.display.set 'area_sqft', area
		acres: (m) ->
			area = ( (m * 10.7639) / 43560 )
			gc.display.set 'area_ac', area
		hectares: (m) ->
			area = ( m / 10000 )
			gc.display.set 'area_ha', area

	# Display of location coordinates
	location:
		lat: (coord) ->
			gc.display.set 'location_lat', coord
		lng: (coord) ->
			gc.display.set 'location_lng', coord