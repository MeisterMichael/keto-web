
# Copied to app from Pulitzer install

class RootController < ApplicationController
	layout 'application_covered'

	include Pulitzer::Concerns::RootConcern

	# this is the homepage!
	def index

		@articles = Pulitzer::Article.published.order(publish_at: :desc)
		@articles = @articles.page(params[:page]).per(3)

		@recipes = Recipe.published.order(publish_at: :desc)
		@recipes = @recipes.page(params[:page]).per(3)

		@bazaar_medias = BazaarMedia.published.order(publish_at: :desc)
		@bazaar_medias = @bazaar_medias.page(params[:page]).per(3)

		@discussion_topics = Scuttlebutt::DiscussionTopic.active.order(created_at: :desc)
		@discussion_topics = @discussion_topics.page(params[:page]).per(4)

		render layout: 'onepage'
	end

	# this handles all media in the pulitzer_media table
	def show

		# get_pulitzer_media is a wrapper on friendly_id that also
		# handles special cases such as the sitemap & handling redirects
		return unless get_pulitzer_media( params[:id] )

		# pulitzer_render renders while handling custom layouts/views
		# via media.layout and media.template
		pulitzer_render( @media )
	end


	# route additional static pages not edited via wysiwyg here
	# e.g.
	# route '/about', to: 'root#about'
	# then here
	# def about
	# 	pull data required for about page.....
	# end

end
