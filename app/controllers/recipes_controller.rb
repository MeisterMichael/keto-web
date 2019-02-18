
class RecipesController < ApplicationController
	layout 'application_covered'

	before_action :set_recipe, only: :show

	def index


		@tags = []# Recipe.published.tags_counts

		@query = params[:q] if params[:q].present?
		@tagged = params[:tagged] || params[:tagged_path].try(:gsub,/\-/,' ')
		@author = User.friendly.find( params[:by] ) if params[:by].present?
		@category = RecipeCategory.friendly.find( params[:category] || params[:cat] ) if ( params[:category] || params[:cat] ).present?

		@titleized_tagged = @tagged.titleize if @tagged

		@title = @category.try(:name)
		@title ||= "#{@titleized_tagged} Recipes"

		@recipes = Recipe.published.order( publish_at: :desc )
		@recipes = @recipes.where( category: @category ) if @category
		@recipes = @recipes.with_any_tags( @tagged ) if @tagged
		@recipes = @recipes.where( user: @author ) if @author

		# set count before pagination
		@count = @recipes.count

		@recipes = @recipes.page( params[:page] )

		set_page_meta( title: @title )

		render layout: 'application_covered'
	end

	def show
		@media = @recipe

		@more_recipes = Recipe.published.order('random()').limit( 3 )

		set_page_meta( @recipe.page_meta )

		render layout: 'application_covered'
	end


  private
	# Use callbacks to share common setup or constraints between actions.
	def set_recipe
		@recipe = Recipe.published.friendly.find( params[:id] )
	end



end
