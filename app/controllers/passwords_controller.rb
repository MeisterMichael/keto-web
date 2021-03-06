class PasswordsController < Devise::PasswordsController

	layout 'sessions'

	#def create
	#	self.resource = resource_class.send_reset_password_instructions(resource_params)
	#	yield resource if block_given?
	#
	#	if successfully_sent?(resource)
	#		redirect_to main_app.forgot_path()
	#	else
	#		respond_with(resource)
	#	end
	#end
	#
	#def after_resetting_password_path_for( resource )
	#	"https://#{ENV['FRONTEND_APP_DOMAIN'] || 'subscribe.neurohacker.com'}/login?reset=success"
	#end

	def create
		log_event name: 'password_reset_create'
		super
	end

	def edit
		log_event name: 'password_reset_edit'
		super
	end

	def new
		log_event name: 'password_reset_new'
		super
	end

	def update
		log_event name: 'password_reset_update'
		super
	end

end
