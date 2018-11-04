class FoodMacrosMigration < ActiveRecord::Migration[5.1]

	def change
		add_column :foods, :measure_unit, :string, default: 'g' # g, ml
		add_column :foods, :usda_ndbno, :string, default: nil
		add_column :foods, :properties, :hstore, default: {}
		add_column :foods, :usda_cache, :json, default: {}
		add_column :foods, :serving_size_in_measure_units, :float, default: nil
		add_column :foods, :serving_size, :text, default: nil

		create_table :food_nutrients do |t|
			t.references 	:food
			t.references 	:nutrient
			# t.float				:amount, default: 1 # per 1 measure_unit of food
			t.float				:amount_per_serving, default: nil
			t.float				:estimated_calories
			t.string 			:notes
			t.timestamps
		end

		create_table :nutrients do |t|
			t.belongs_to :parent
			t.string		:title
			t.string		:fact_name
			t.string		:slug
			t.integer		:position #in the nutrition fact chart
			t.string		:avatar
			t.float			:daily_recommended_value, default: nil # in base unit
			t.float			:daily_recommended_keto_value, default: nil # in base unit
			t.float			:calories_per_unit, default: nil
			t.string		:unit, default: 'g' # g, ml, kcal


			t.text 			:description
			t.text 			:content

			t.string		:usda_nutrient_id, default: nil

			t.json			:usda_cache, default: {}
			t.hstore		:properties, default: {}
			t.timestamps
		end


		create_table :food_measures do |t|
			t.belongs_to :food
			t.string		:unit
			t.float			:quantity
			t.float			:equivalent_measure_units
			t.timestamps
		end

	end

end
