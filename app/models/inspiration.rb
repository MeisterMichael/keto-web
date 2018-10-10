
class Inspiration < Pulitzer::Media


	def layout
		self[:layout] || 'onepage'
	end

	def template
		self[:template] || 'inspirations/show'
	end
end
