
class FoodNutrientsController < ApplicationController

	def show
		@food = Food.friendly.find( params[:food_id] )
		raise ActionController::RoutingError.new('Not Found') unless @food
		@food.force_fetch_details! if @food.food_nutrients.count <= 2
		@food.fetch_details!

		nutrient_name = params[:nutrient_name].try(:gsub,/\-/,' ').try(:gsub,/\s*in$/,'').try(:strip)
		@nutrient = Nutrient.where( "LOWER(fact_name) IN (?)", [nutrient_name.downcase,nutrient_name.downcase.singularize,nutrient_name.downcase.pluralize] ).first if nutrient_name
		raise ActionController::RoutingError.new('Not Found') unless @nutrient

		@food_measure = @food.food_measures.first

		@food_nutrient = @food.food_nutrients.find_by( nutrient: @nutrient )

		# "How many #{@nutrient.fact_name.downcase.pluralize} are in #{@food.title}, #{@food_measure.quantity} #{@food_measure.unit}""
		@title = "How many #{@nutrient.fact_name.pluralize} are in #{@food.title}?"
		@answer = "#{@food_measure.quantity.to_s.gsub(/\.0$/,'')} #{@food_measure.unit} contains #{@food_nutrient.amount_per_serving}#{%w( g ml ).include?( @nutrient.unit.downcase ) ? @nutrient.unit : ''} #{@food_nutrient.amount_per_serving > 1.0 ? @nutrient.fact_name.downcase.pluralize : @nutrient.fact_name.downcase.singularize}."

		@structured_data = {
			"@context" => "https://schema.org",
			"@type" => "QAPage",
			"mainEntity" => {
				"@type" => "Question",
				"name" => @title,
				# "text" => "...",
				"answerCount" => 1,
				"dateCreated" => @food.updated_at.iso8601,
				"acceptedAnswer" => {
					"@type" => "Answer",
					"text" => @answer,
					"dateCreated" => ( @food_nutrient.updated_at + (@food_nutrient.id % 60).minutes ).iso8601,
				},
			}
		}

		set_page_meta( title: @title )
	end

end
