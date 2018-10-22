class NotificationsMailer < ApplicationMailer


	def post( subscription, post )
		@from = post.user
		@to = subscription.user
		@post = post
		@subscription = subscription
		@parent_obj = @subscription.parent_obj
		mail to: @to.email, subject: "#{@from.first_name} posted a message"
	end


end
