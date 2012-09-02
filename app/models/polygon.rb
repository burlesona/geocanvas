class Polygon
	
	def initialize( points = nil )
		if points.instance_of? Array
			@points = points
		else
			@points = Array.new
		end	
	end

	def points
		@points
	end

	def append_point( point )
		if point.instance_of? Array
			@points << point
		else
			raise "Points must be LatLng Arrays"
		end
	end

	def remove_last_point
		@points.pop
	end

	def clear_points
		@points = Array.new
	end

end