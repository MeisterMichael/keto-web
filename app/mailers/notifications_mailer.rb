class NotificationsMailer < ApplicationMailer


	def post( subscription, post, args = {} )
		args[:subject] = 'posted a message'
		args[:subject] = 'posted a discussion topic' if post.is_a? Scuttlebutt::DiscussionTopic

		@from = post.user
		@to = subscription.user
		@post = post
		@subscription = subscription
		@parent_obj = @subscription.parent_obj
		mail to: @to.email, subject: "#{@from.first_name} #{args[:subject]}"
	end


end
