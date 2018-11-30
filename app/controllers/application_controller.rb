class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception

	include Pulitzer::Concerns::ApplicationControllerConcern
	include SwellId::Concerns::ApplicationControllerConcern
	include Devise::Controllers::Helpers

	before_action :register_then
	before_action :set_page_meta


	# def after_sign_in_path_for(resource)
	# 	if ( oauth_uri = session.delete(:oauth_uri) ).present?
	# 		return oauth_uri
	# 	elsif resource.admin?
	# 		return '/admin'
	# 	else
	# 		return '/'
	# 	end
	# end

	protected
		def client_ip
			request.headers['CF-Connecting-IP'] || request.remote_ip
		end

		def client_ip_country
			request.headers['CF-IPCountry']
		end

		def log_event( opts={} )

			if %w(add_post comment).include? opts[:name]
				target_obj = opts[:on] || opts[:target_obj]

				# email a subscribers posts and comments
				post = Scuttlebutt::Post.where( user: current_user ).last
				Scuttlebutt::Subscription.where( parent_obj: target_obj ).where.not( user: current_user ).each do |subscription|
					NotificationsMailer.post( subscription, post ).deliver_now
				end
			end

			if %w(add_topic).include? opts[:name]
				listening_admin_usernames = (ENV['LISTENING_ADMINS_USERNAMES'] || '').split(/\s+/).collect(&:strip)
				listening_admins = User.admin.where( username: listening_admin_usernames ) #.where.not( id: current_user.id )
				posters_subscriptions = Scuttlebutt::Subscription.where( parent_obj: current_user ).where.not( user: listening_admins ).where.not( user: current_user )

				target_obj = opts[:on] || opts[:target_obj]
				post = Scuttlebutt::Post.where( user: current_user ).last

				# email a users subscribers when they post a new topic
				posters_subscriptions.each do |subscription|
					NotificationsMailer.post( subscription, post ).deliver_now
				end

				# email select admins whenever a user creates a topic.
				listening_admins.each do |user|
					NotificationsMailer.post( Scuttlebutt::Subscription.new( parent_obj: current_user, user: user ), post ).deliver_now
				end
			end



			true
		end

end
