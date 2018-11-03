class FoodMacrosMigration < ActiveRecord::Migration[5.1]

	def change

		add_column :foods, :serving_size_weight, :float, default: nil
		add_column :foods, :serving_size, :text, default: nil


		create_table :food_nutrients do |t|
			t.references 	:food
			t.references 	:nutrient
			t.float				:amount, default: nil
			t.string 			:unit, default: nil
			t.float				:weight # grams
			t.float				:estimated_calories
			t.string 			:notes
			t.timestamps
		end

		create_table :nutrients do |t|
			t.belongs_to :parent
			t.string		:title
			t.string		:slug
			t.integer		:position #in the nutrition fact chart
			t.string		:avatar
			t.float			:daily_recommended_value, default: nil # grams
			t.float			:daily_recommended_keto_value, default: nil # grams
			t.float			:calories_per_gram, default: nil
			t.text 			:description
			t.text 			:content
			t.timestamps
		end

	end

end
