
class FoodsController < ApplicationController

	def list

		@tagged = params[:tagged] || params[:tagged_path].try(:gsub,/\-/,' ')
		@titleized_tagged = @tagged.titleize if @tagged

		@foods = Food.keto.published.order( title: :asc )
		@foods = @foods.with_any_tags( [@tagged.singularize, @tagged.pluralize, @tagged] ) if @tagged
		@foods = @foods.page( params[:page] ).per(40)

		@title = "#{@titleized_tagged.singularize} Foods" if @titleized_tagged && @foods.total_count > 0
		@title ||= "Keto Diet Foods"

		set_page_meta( title: @title )

	end

	def index
		@query = params[:q]

		if @query
			@foods = UsdaFood.usda_search( @query, db: :standard, sort: :relevance )
			@foods = @foods + UsdaFood.usda_search( @query, db: :branded, sort: :relevance )
			@foods.collect(&:save)
			@foods = @foods.select(&:active?) + @foods.select(&:draft?)
		else
			@foods = Food.not_recipe.published.order( created_at: :desc ).page(params[:page]).per(20)
		end

		set_page_meta( title: "Nutrition Search Results" )

	end

	def show
		@food = Food.friendly.find( params[:id] )
		if @food.respond_to? :fetch_details!
			@food.force_fetch_details! if @food.food_nutrients.count <= 2
			@food.fetch_details!
		end

		@measure_unit = @food.measure_unit
		# @food_measure = @food.food_measures.where( "LOWER(  || ' ' ||) = ?", params[:measure] ) if params[:measure].present?
		@food_measure = @food.food_measures.where( id: params[:food_measure_id] ).first if params[:food_measure_id].present?
		@food_measure ||= @food.food_measures.first

		set_page_meta( title: "#{@food.title} - Keto Nutrition Facts" )
	end

end
