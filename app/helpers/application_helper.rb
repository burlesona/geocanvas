module ApplicationHelper

	def map_canvas
		content_tag :div, nil, id: 'map_canvas',
			data: {
				polygons_url: polygons_url
			}
	end

end
