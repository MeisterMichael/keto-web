
class Inspiration < Pulitzer::Media


	def layout
		self[:layout] || 'application'
	end

	def template
		self[:template] || 'pulitzer/pages/show'
	end
end
