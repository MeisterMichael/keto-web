
class Recipe < Food
	include RecipeSearchable

	validates		:title, presence: true, unless: :allow_blank_title?

	belongs_to :recipe_category, foreign_key: :category_id, required: false

	has_many :ingredients
	has_many :foods, through: :ingredients


	mounted_at '/recipes'

	def page_meta
		if self.title.present?
			title = "#{self.title} )°( #{Pulitzer.app_name}"
		else
			title = Pulitzer.app_name
		end

		return {
			page_title: title,
			title: self.title,
			description: self.sanitized_description,
			image: self.avatar,
			url: self.url,
			twitter_format: 'summary_large_image',
			type: 'Article',
			og: {
				"article:published_time" => self.publish_at.iso8601,
			},
			data: {
				'url' => self.url,
				'name' => self.title,
				'description' => self.sanitized_description,
				'datePublished' => self.publish_at.iso8601,
				'image' => self.avatar
			}

		}
	end
end
