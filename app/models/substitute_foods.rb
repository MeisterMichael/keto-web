
class SubstituteFood < ActiveRecord::Base

	belongs_to :substitutes
	belongs_to :food

end
