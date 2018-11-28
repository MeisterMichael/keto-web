
class UsdaFoodAdminController < AdminController


	def index
		@usda_foods = UsdaFood.none
		@usda_foods = UsdaFood.usda_search( params[:q] ) if params[:q]
		@usda_foods.collect(&:save)

	end

	def show
		@food = UsdaFood.friendly.find( params[:id] )
		@food.fetch_details!

		@measure_unit = params[:measure_unit] || @food.measure_unit
	end

end
