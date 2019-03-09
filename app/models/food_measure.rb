
class FoodMeasure < ActiveRecord::Base

	belongs_to :food

	def to_s
		"#{quantity} #{unit} (#{equivalent_measure_units}#{food.measure_unit})"
	end

end
