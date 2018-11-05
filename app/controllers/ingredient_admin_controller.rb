
class IngredientAdminController < AdminController

	def create
		@food = UsdaFood.friendly.find( params[:id] )
		@food.fetch_details!

		@measure_unit = params[:measure_unit] || @food.measure_unit
	end

end
