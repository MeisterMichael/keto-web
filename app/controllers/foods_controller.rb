
class FoodsController < ApplicationController

	def index
		@query = params[:q]

		@foods = UsdaFood.none
		@foods = UsdaFood.usda_search( @query, db: :standard, sort: :relevance ) if @query
		@foods = @foods + UsdaFood.usda_search( @query, db: :branded, sort: :relevance ) if @query
		@foods.collect(&:save)

		set_page_meta( title: "Nutrition Search Results" )

	end

	def show
		@food = Food.friendly.find( params[:id] )
		@food.force_fetch_details! if @food.food_nutrients.count <= 2
		@food.fetch_details!

		@measure_unit = @food.measure_unit
		# @food_measure = @food.food_measures.where( "LOWER(  || ' ' ||) = ?", params[:measure] ) if params[:measure].present?
		@food_measure = @food.food_measures.where( id: params[:food_measure_id] ).first if params[:food_measure_id].present?
		@food_measure ||= @food.food_measures.first

		set_page_meta( title: "#{@food.title} - Keto Nutrition Facts" )
	end

end
