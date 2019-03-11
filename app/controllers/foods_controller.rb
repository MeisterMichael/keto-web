
class FoodsController < ApplicationController

	def index
		@query = params[:q]

		@foods = UsdaFood.none
		@foods = UsdaFood.usda_search( @query, db: :standard, sort: :relevance ) if @query
		@foods.collect(&:save)

		set_page_meta( title: "Nutrition Search Results" )

	end

	def show
		@food = UsdaFood.friendly.find( params[:id] )
		@food.fetch_details!

		@measure_unit = @food.measure_unit

		set_page_meta( title: "#{@food.title} - Keto Nutrition Facts" )
	end

end
