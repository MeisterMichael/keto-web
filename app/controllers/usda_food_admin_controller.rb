
class UsdaFoodAdminController < AdminController
	before_action :set_food, only: [:show, :edit, :preview, :update, :destroy]


	def edit
		@food.fetch_details!

		@measure_unit = params[:measure_unit] || @food.measure_unit
	end


	def index
		@usda_foods = UsdaFood.none
		@usda_foods = UsdaFood.usda_search( params[:q] ) if params[:q]
		@usda_foods.collect(&:save)

	end

	def show
		@food.fetch_details!

		@measure_unit = params[:measure_unit] || @food.measure_unit
	end

	def update

		@food.attributes = food_params
		@food.slug = nil if @food.title_changed?

		if @food.save
			set_flash 'Food Updated'
			redirect_to edit_usda_food_admin_path( id: @food.id )
		else
			set_flash 'Food could not be Updated', :error, @food
			render :edit
		end

	end

	private
		def food_params
			params.require( :food ).permit( :title, :description, :avatar, :content, :status, :availability, :prep_time, :cook_time, :serves, :tags_csv, :category_id, :avatar_attachment, :cover_attachment, :nutrition_facts_attachment, :parse_nutrient_facts, { embedded_attachments: [], other_attachments: [] } )
		end

		def set_food
			@food = UsdaFood.friendly.find( params[:id] )
		end

end
