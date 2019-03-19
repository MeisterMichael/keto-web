# rake sitemap:refresh

SitemapGenerator::Sitemap.adapter = SitemapGenerator::S3Adapter.new(
	fog_provider:			'AWS',						# required
	aws_access_key_id:		ENV['AMZN_ASOC_KEY'],		# required
	aws_secret_access_key:	ENV['AMZN_ASOC_SECRET'],	# required
	fog_path_style:			true,
	fog_region:				'us-west-1',				# optional, defaults to 'us-east-1'
)

SitemapGenerator::Sitemap.create_index = :auto
SitemapGenerator::Sitemap.default_host = "https://simpleketo.us"
SitemapGenerator::Sitemap.public_path = 'tmp/'

SitemapGenerator::Sitemap.sitemaps_host = "http://#{ENV['FOG_DIRECTORY']}.s3.amazonaws.com/"
SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'

SitemapGenerator::Sitemap.create do

	add '/'
	add '/discussions'
	add "/articles"
	add '/keto-diet-foods', lastmod: Food.where( type: 'Recipe' ).or( Food.where( type: 'UsdaFood' ).with_any_tags( %w(keto) ) ).published.order( updated_at: :desc ).first.try(:updated_at)
	add "/recipes"
	add '/shop'

	BazaarMedia.published.each do |media|
		add media.path, lastmod: media.updated_at
	end

	Pulitzer::Media.published.each do |media|
		add media.path, lastmod: media.updated_at
	end

	Scuttlebutt::DiscussionTopic.active.each do |post|
		add post.path, lastmod: post.updated_at
	end

	Recipe.published.media_tag_cloud(limit: 100000).sort_by{|r| -r.second}.collect(&:first).each do |tag|
		updated_at = Recipe.published.with_any_tags( tag ).order( updated_at: :desc ).first.try(:updated_at)
		recipes_path = Rails.application.routes.url_helpers.tagged_recipes_path( tagged_path: tag.gsub(/\s/,'-') )

		add recipes_path, lastmod: updated_at
	end

	Recipe.published.find_each do |recipe|
		add recipe.path, lastmod: recipe.updated_at
	end

	UsdaFood.published.find_each do |food|
		add food.path, lastmod: food.updated_at

		food.food_measures.find_each do |food_measure|
			add Rails.application.routes.url_helpers.food_measure_path( food_measure, only_path: true ), lastmod: [food.updated_at,food_measure.updated_at].max
		end

		food.food_nutrients.includes(:nutrient).find_each do |food_nutrient|
			puts Rails.application.routes.url_helpers.food_nutrient_path( food_id: food.slug, nutrient_name: food_nutrient.nutrient.fact_name.parameterize, only_path: true ), lastmod: [food.updated_at,food_nutrient.updated_at].max
		end
	end

	Dewey::Course.published.find_each do |course|
		add course.path, lastmod: course.updated_at
	end

	Food.where( type: 'Recipe' ).or( Food.where( type: 'UsdaFood' ).with_any_tags( %w(keto) ) ).published.media_tag_cloud(limit: 100000).sort_by{|r| -r.second}.collect(&:first).each do |tag|
		updated_at = Food.published.with_any_tags( tag ).order( updated_at: :desc ).first.try(:updated_at)
		foods_path = Rails.application.routes.url_helpers.tagged_list_foods_path( tagged_path: tag.gsub(/\s/,'-') )
		add foods_path, lastmod: updated_at
	end

end
