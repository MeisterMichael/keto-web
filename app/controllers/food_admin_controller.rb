
class FoodAdminController < AdminController
	before_action :set_food, only: [:show, :edit, :preview, :update, :destroy]


	def create
		@food = Food.new

		@food.attributes = food_params

		if @food.save
			set_flash 'Food Updated'
			redirect_to edit_food_admin_path( id: @food.id )
		else
			set_flash 'Food could not be Updated', :error, @food
			render :edit
		end

	end

	def edit
		@food.fetch_details! if @food.respond_to? :fetch_details!
	end

	def index
		by = params[:by] || 'title'
		dir = params[:dir] || 'asc'
		@foods = Food.order( "#{by} #{dir}" )
		if params[:q]
			match = params[:q].downcase.singularize.gsub( /\s+/, '' )
			@foods = @foods.where( "lower(REGEXP_REPLACE(title, '\s', '' )) = :m", m: match )
			@foods << Food.find_by_alias( match )
		end
		@food_count = @foods.count
		@foods = @foods.page( params[:page] )

	end

	def update

		@food.attributes = food_params
		@food.slug = nil if @food.title_changed?

		@food.food_nutrients.where.not( nutrient_id: food_nutrients_params.keys ).destroy_all
		food_nutrients_params.each do |nutrient_id,fn_attributes|
			food_nutrient = @food.food_nutrients.where( nutrient_id: nutrient_id ).first_or_initialize
			food_nutrient.attributes = fn_attributes
			food_nutrient.save
		end

		@food.food_measures.where.not( unit: food_measures_params.to_h.collect{|key,value| value[:unit] } ).destroy_all
		food_measures_params.each do |index,fm_attributes|
			food_measure = @food.food_measures.where( unit: fm_attributes[:unit] ).first_or_initialize
			food_measure.attributes = fm_attributes
			food_measure.save
		end

		if @food.save
			set_flash 'Food Updated'
			redirect_to edit_food_admin_path( id: @food.id )
		else
			set_flash 'Food could not be Updated', :error, @food
			render :edit
		end

	end

	private
		def food_params
			params.require( :food ).permit( :title, :publish_at, :description, :serving_size, :serving_size_in_measure_units, :measure_unit, :avatar, :content, :status, :availability, :prep_time, :cook_time, :serves, :tags_csv, :category_id, :avatar_attachment, :cover_attachment, :nutrition_facts_attachment, :parse_nutrient_facts, { embedded_attachments: [], other_attachments: [] } )
		end

		def food_nutrients_params
			food_nutrients = params.require( :food_nutrients ).permit!
			food_nutrients = food_nutrients.select do |key,value|
				value[:amount_per_serving].present?
			end
			food_nutrients
		end

		def food_measures_params
			food_measures = params.require( :food_measures ).permit!
			food_measures = food_measures.select do |key,value|
				value[:quantity].present? && value[:unit].present? && value[:equivalent_measure_units].present?
			end
			food_measures
		end

		def set_food
			@food = Food.friendly.find( params[:id] )
		end

end
