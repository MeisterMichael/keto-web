
class UsersController < ApplicationController
	layout 'application_covered'

	before_action :get_user, only: :show

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
