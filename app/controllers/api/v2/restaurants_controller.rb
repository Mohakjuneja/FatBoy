module Api
  module V2
    class RestaurantsController < Api::BaseController
    	def index
    		format.json { render json: {total: "testing"}, status: :ok }
    	end
	end
  end
end