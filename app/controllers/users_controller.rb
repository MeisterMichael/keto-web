
class UsersController < ApplicationController
	layout 'application_covered'

	before_action :get_user, only: :show

	def index
		@cover_image = Recipe.published.order('random()').first.try(:cover_image)
		
		@users = User.active

		if (term = params[:q]).present?
			query = "%#{term.gsub('%','\\\\%')}%".downcase
			@users = @users.where( "username ILIKE :q OR (first_name || ' ' || last_name) ILIKE :q", q: query )
		end

		@users = @users.order( created_at: :desc ).page( params[:page] ).per( 20 )

		set_page_meta( title: 'Members' )
	end

	def show
		@cover_image = Recipe.published.order('random()').first.try(:cover_image)

		@posts = @user.posts.active.anyone
		@posts = @posts.where( type: ['Scuttlebutt::DiscussionTopic'] ) #, 'Scuttlebutt::DiscussionPost'
		@posts = @posts.order( created_at: :desc ).page( params[:page] ).per( 20 )

		set_page_meta( @user.page_meta )

		render layout: 'application_covered'
	end


  private

	def get_user
		@user = User.friendly.find params[:id]
	end



end
