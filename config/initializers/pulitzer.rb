Pulitzer.configure do |config|

	config.app_name = ENV['APP_NAME'] || 'KetoSelf'

	config.app_host = ENV['APP_DOMAIN'] || 'localhost:3000'
	config.app_description = "ketoself description."

	# config.app_logo = ''

	config.default_page_meta = {
		twitter_format: 'summary',
		twitter_site: '@ketoself',
	}


	config.site_map_url = "https://cdn1.ketoself.com/sitemaps/sitemap.xml.gz"

	config.default_protocol = 'https' unless Rails.env.development?

	config.froala_editor_key = ENV['FROALA_EDITOR_KEY']

	config.contact_email_to 	= 'mike@ketoself.com'
	config.contact_email_from 	= 'mike@ketoself.com'

end
