class SwipesController < ApplicationController
	def index
		@swipes = current_user.swipes
    @purchases = current_user.purchases
	end
end
