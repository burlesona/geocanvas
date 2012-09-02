class PolygonsController < ApplicationController
	# This controller is only part of the API for Javascript interactions
	respond_to :json

	def index
		@poly = [
			[29.74, -95.40],
			[29.74, -95.41],
			[29.75, -95.41],
			[29.75, -95.40],
			[29.74, -95.40]
		]

		respond_with @poly
	end

	def show
	end

	def create
	end

	def update
	end

	def destroy
	end

end
