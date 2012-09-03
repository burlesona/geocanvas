class PolygonsController < ApplicationController
	respond_to :json
	before_filter :load_points

	def index
	end

	def show
		@poly = { id: params[:id], points: @points }
		respond_with @poly
	end

	def create
	end

	def update
	end

	def destroy
	end

	# Temporary method for testing some JS.
	def load_points
		@points= [
			[29.74, -95.40],
			[29.74, -95.41],
			[29.75, -95.41],
			[29.75, -95.40],
			[29.74, -95.40]
		]
	end

end
