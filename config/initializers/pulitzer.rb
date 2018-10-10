Pulitzer.configure do |config|

	config.app_name = ENV['APP_NAME'] || 'KETO&CO'

	config.app_host = ENV['APP_DOMAIN'] || 'localhost:3000'
	config.app_description = "KETO&CO description."

	# config.app_logo = ''

	config.default_page_meta = {
		twitter_format: 'summary',
		twitter_site: '@ketoandco',
	}


	config.site_map_url = "https://cdn1.ketoandco.com/sitemaps/sitemap.xml.gz"

	config.default_protocol = 'https' unless Rails.env.development?

	config.froala_editor_key = ENV['FROALA_EDITOR_KEY']

	config.contact_email_to 	= 'mike@ketoandco.com'
	config.contact_email_from 	= 'mike@ketoandco.com'

end
