
# https://ndb.nal.usda.gov/ndb/doc/apilist/API-LIST.md
class UsdaFood < Food

	def self.base_unit( unit )
		if Measurement::Unit[unit].present?
			return 'g' if Measurement::Unit[unit].aliases.select{|a| a.include? 'gram' }.present?
			return 'ml' if Measurement::Unit[unit].aliases.select{|a| a.include? 'liter' }.present?
		end
		nil
	end

	def self.usda_search( term, args = {} )
		params = {
			format: :json,
			lt: :f, #food
			max: 25,
			offset: 0,
			api_key: (ENV['DATA_GOV_API_KEY'] || 'DEMO_KEY'),
		}.merge(args[:params] || {}).merge({ q: term })

		params[:sort] ||= 'r' if args[:sort].to_s == 'relevance' # search relevance
		params[:sort] ||= 'n' # name

		params[:ds] = 'Standard Reference' if args[:db].to_s == 'standard'
		params[:ds] = 'Branded Food Products' if args[:db].to_s == 'branded'
		puts params.to_json
		json = RestClient.get("https://api.nal.usda.gov/ndb/search/?#{params.to_query}")
		# puts "response #{json}"
		response = JSON.parse( json )

		foods = []
		if response['list']
			foods = response['list']['item'].collect do |item|
				UsdaFood.create_with(
					title: item['name'],
					usda_cache: item,
					properties: { 'status' => 'search' },
				).find_or_initialize_by( usda_ndbno: item['ndbno'] )
			end
		end

		foods

	end

	def fetch_details!( args = {} )
		force_fetch_details! unless self.properties['status'] == 'detailed'
	end

	def force_fetch_details!( args = {} )

		params = {
			format: :json,
			type: :f,
			ndbno: self.usda_ndbno,
			api_key: (ENV['DATA_GOV_API_KEY'] || 'DEMO_KEY'),
		}

		json = RestClient.get("https://api.nal.usda.gov/ndb/reports/?#{params.to_query}")
		response = JSON.parse( json )

		self.usda_cache = response['report']['food']
		self.serving_size_in_measure_units = 100
		self.measure_unit = response['report']['food']['ru']
		self.serving_size = "#{self.serving_size_in_measure_units}#{self.measure_unit}"
		self.properties = self.properties.merge( 'status' => 'detailed' )
		self.save

		# add measures for food.
		self.food_measures.delete_all
		self.usda_cache['nutrients'].first['measures'].each do |measure|
			self.food_measures.create_with(
				equivalent_measure_units: measure['eqv'].to_f,
			).find_or_create_by( unit: measure['label'].downcase, quantity: measure['qty'].to_f )
		end

		# update nutrients
		self.food_nutrients.delete_all
		self.usda_cache['nutrients'].each do |nutrient_row|
			if nutrient_row['unit'] == 'kJ'
				nutrient_row['unit'] = 'kcal'
				nutrient_row['value'] = nutrient_row['value'].to_f / 4.184
			end

			nutrient = Nutrient.create_with(
				usda_cache: nutrient_row,
				title: nutrient_row['name'],
				unit: UsdaFood.base_unit( nutrient_row['unit'] ) || nutrient_row['unit'],
			).find_or_create_by( title: nutrient_row['name'] )
			#.find_or_create_by( usda_nutrient_id: nutrient_row['nutrient_id'].to_s )

			amount_per_serving = nutrient_row['value'].to_f
			amount_per_serving = Measurement.parse("#{amount_per_serving} #{nutrient_row['unit']}").convert_to(nutrient.unit).quantity if nutrient.unit != nutrient_row['unit']

			self.food_nutrients.create(
				nutrient: nutrient,
				amount_per_serving: amount_per_serving,
			)
		end


		nutrient = Nutrient.find_or_create_by( title: "Net Carbohydrates" )
		self.food_nutrients.create( nutrient: nutrient, amount_per_serving: FoodNutrient.net_carb_weight( self.food_nutrients ) )


		self.usda_cache
	end

	def to_s
		keto_food_nutrients = self.food_nutrients.joins(:nutrient).merge(Nutrient.where(title: ["Net Carbohydrates", "Protein", "Total lipid (fat)"]))
		measure = self.food_measures.first
		keto_food_nutrients = keto_food_nutrients
		"#{super()} ( #{keto_food_nutrients.collect{|n| n.for_measure( measure ).to_s }.join(' | ')} per #{measure} )"
	end

end
