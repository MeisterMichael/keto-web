Pulitzer.configure do |config|

	config.app_name = ENV['APP_NAME'] || 'SIMPLEKETO.'

	config.app_host = ENV['APP_DOMAIN'] || 'localhost:3000'
	config.app_description = "SIMPLEKETO."

	# config.app_logo = ''

	config.default_page_meta = {
		twitter_format: 'summary',
		twitter_site: '@simpleketo',
	}


	config.site_map_url = "https://cdn1.simpleketo.us/sitemaps/sitemap.xml.gz"

	config.default_protocol = 'https' unless Rails.env.development?

	config.froala_editor_key = ENV['FROALA_EDITOR_KEY']

	config.contact_email_to 	= 'mike@simpleketo.us'
	config.contact_email_from 	= 'mike@simpleketo.us'

end
