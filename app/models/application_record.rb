class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

	def cache_key
		"#{super()}-#{(self.updated_at || Time.now).utc.to_s(:number)}"
	end
end
