class MemberRole < ApplicationRole

	def authorize( target, options = {} )
		not_allowed! unless options[:controller].present? && not( options[:controller] < ApplicationAdminController )
		not_allowed! if target.respond_to?( :authorized_users? ) && target.authorized_users? && current_user.enrollments.blank?
		true
	end

end
