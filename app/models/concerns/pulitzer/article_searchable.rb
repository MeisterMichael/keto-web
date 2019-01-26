module Pulitzer
	module ArticleSearchable
		extend ActiveSupport::Concern

		included do
			index_name Pulitzer::Media.__elasticsearch__.index_name
		end

	end

end
