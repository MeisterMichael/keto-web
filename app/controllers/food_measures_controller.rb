
class FoodMeasuresController < ApplicationController

	def show
		@food = Food.friendly.find( params[:food_id] )
		@food.force_fetch_details! if @food.food_nutrients.count <= 2
		@food.fetch_details!

		@measure_unit = @food.measure_unit
		@food_measure = @food.food_measures.to_a.select{ |food_measure| food_measure.unit.parameterize == params[:unit] }.first

		@quantity = params[:qty] || params[:quantity] || @food_measure.quantity
		@unit = @food_measure.unit

		@food_measure.scale_quantity_to( @quantity )

		@title = "#{@food.title}, #{@quantity} #{@unit}"

		set_page_meta( title: "#{@title} - Keto Nutrition Facts" )
	end

end
