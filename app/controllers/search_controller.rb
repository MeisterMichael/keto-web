
# Copied to app from Pulitzer install

class SearchController < ApplicationController

	# this is the homepage!
	def index
		set_page_meta(
			{
				title: 'Search - Neurohacker Collective',
			}
		)

		@results = Searchable.public_simple_search( params[:q] ).page( params[:page] ).per(20) if params[:q].present?
		@results ||= Pulitzer::Media.none.page( params[:page] ).per(20)

	end

end
