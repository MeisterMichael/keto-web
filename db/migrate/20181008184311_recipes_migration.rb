class RecipesMigration < ActiveRecord::Migration[5.1]
	def change

		create_table :foods do |t|
			t.string 		:title
			t.string 		:slug
			t.string 		:description
			t.text 			:content
			t.string 		:avatar
			t.text 			:nutrition
			t.timestamps
		end
		add_index :foods, :slug, unique: true

		create_table :ingredients do |t|
			t.references 	:recipe
			t.references 	:food
			t.string		:amount
			t.string 		:unit
			t.string 		:notes
			t.timestamps
		end

		create_table :recipes do |t|
			t.references :category
			t.string 		:title
			t.string 		:description
			t.text 			:content
			t.text 			:avatar
			t.text 			:cover_image
			t.string 		:slug
			t.string 		:prep_time
			t.string 		:cook_time
			t.string 		:serves
			t.string 		:nutrition
			t.text 			:tags, array: true, default: []
			t.integer 	:status, default: 0
			t.datetime 	:publish_at
			t.timestamps
		end
		add_index :recipes, :slug, unique: true
    add_index :recipes, [:tags], using: :gin

	end
end
