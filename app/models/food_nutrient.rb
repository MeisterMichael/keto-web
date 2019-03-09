
class FoodNutrient < ActiveRecord::Base

	before_save :set_defaults

	belongs_to :nutrient
	belongs_to :food

	def for_measure( food_measure )
		multiplier = food_measure.equivalent_measure_units / food.serving_size_in_measure_units

		food_nutrient = FoodNutrient.new(
			nutrient: self.nutrient,
			food: self.food,
			amount_per_serving: (amount_per_serving * multiplier).round(10),
		)
		food_nutrient.estimated_calories = (estimated_calories * multiplier).round(10) unless estimated_calories.nil?

		food_nutrient
	end

	def daily_recommended_percent
		if nutrient.daily_recommended_value.present? && nutrient.daily_recommended_value > 0
			self.amount_per_serving / self.nutrient.daily_recommended_value
		else
			nil
		end
	end

	def daily_recommended_keto_percent
		if nutrient.daily_recommended_keto_value.present? && nutrient.daily_recommended_keto_value > 0
			self.amount_per_serving / self.nutrient.daily_recommended_keto_value
		else
			nil
		end
	end

	def self.parse( text )
		relation = self

		text = text.strip.gsub(/mcg/,'micrograms')
		rows = text.split("\n")
		rows = rows.select do |row|
			row =~ /\d/
		end

		parsed_rows = rows.collect do |row|
			parts = [[]]
			row.split(/\s|\t/).each do |part|
				parts << [] if part =~ /\d/
				parts[parts.count-1] << part
			end

			parts.collect do |part|
				joined_part = part.join(' ')
				begin
					Measurement.parse(joined_part).convert_to(:grams)
				rescue ArgumentError => e
					joined_part = [joined_part.to_f / 100.0,'%'] if joined_part.ends_with? '%'
					joined_part = joined_part.to_f if Float(joined_part) rescue joined_part
				end
			end
		end

		food_nutrients = parsed_rows.collect do |row|
			if row.count == 2

				if row.second.is_a? Measurement

					nutrient = Nutrient.find_or_create_by_measurement( row.first, row.second )
					relation.new( nutrient: nutrient, weight: row.second.quantity )

				else

					nutrient = Nutrient.find_or_create_by_title( row.first )
					relation.new( nutrient: nutrient, amount: row.second.to_f )

				end

			elsif row.count == 3

				weight = row.second.quantity
				percent_value = row.last.first
				daily_recommended_value = (weight * percent_value.to_f * 100.0).round( 6 ) if percent_value > 0

				nutrient = Nutrient.find_or_create_by_measurement( row.first, row.second )
				nutrient.update( daily_recommended_value: daily_recommended_value ) if daily_recommended_value.present? && daily_recommended_value > 0 && nutrient.daily_recommended_value.to_i == 0
				relation.new( nutrient: nutrient, weight: weight )

			else
				die()
			end
		end

		nutrient = Nutrient.where( title: "Net Carbohydrates" ).first_or_create
		food_nutrients << relation.new( nutrient: nutrient, weight: FoodNutrient.net_carb_weight( food_nutrients ) )

		food_nutrients

	end

	def self.net_carb_weight( food_nutrients )
		total_carbohydrates = food_nutrients.select{ |food_nutrient| food_nutrient.nutrient.fact_name.downcase == 'total carbohydrate' }.first
		fiber = food_nutrients.select{ |food_nutrient| food_nutrient.nutrient.fact_name.downcase == 'Dietary Fiber'.downcase }.first

		puts "fiber #{fiber}; total_carbohydrates #{total_carbohydrates}"
		(total_carbohydrates.try(:amount_per_serving) || 0) - (fiber.try(:amount_per_serving) || 0)
	end

	def to_s
		str = "#{self.nutrient.fact_name} #{self.amount_per_serving}#{self.nutrient.unit}"
		str = "#{str} / #{(self.daily_recommended_percent * 100.0).round(2)}% dv" if self.daily_recommended_percent
		str = "#{str} / #{(self.daily_recommended_keto_percent * 100.0).round(2)}% dkv" if self.daily_recommended_keto_percent

		str
	end

	protected
	def set_defaults

		self.estimated_calories = self.nutrient.calories_per_unit * self.amount_per_serving if self.nutrient.calories_per_unit.present? && self.amount_per_serving.present?

	end

end
=begin
text = <<STRING
Calories\t533
% Daily Value*
Total Fat 54.8g\t70%
Saturated Fat 31.9g\t159%
Cholesterol 449mg\t150%
Sodium 450mg\t20%
Total Carbohydrate 0.7g\t0%
Dietary Fiber 0g\t0%
Total Sugars 0.7g
Protein 11.6g
Vitamin D 63mcg\t313%
Calcium 60mg\t5%
Iron 2mg\t9%
Potassium 132mg\t3%
STRING
=end
