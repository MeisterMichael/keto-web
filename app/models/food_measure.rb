
class FoodMeasure < ActiveRecord::Base

	belongs_to :food

	def scale_quantity_to( qty )
		ratio = qty.to_f / self.quantity.to_f
		self.quantity = qty
		self.equivalent_measure_units = self.equivalent_measure_units * ratio

		self
	end

	def to_s
		"#{quantity} #{unit} (#{equivalent_measure_units}#{food.measure_unit})"
	end

end
