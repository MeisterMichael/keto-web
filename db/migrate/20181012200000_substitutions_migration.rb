class SubstitutionsMigration < ActiveRecord::Migration[5.1]
	def change

		create_table :substitutes do |t|
			t.references	:substituted_food, polymorphic: true, index: { name: 'index_substitutes_on_substituted_food' }
			t.references	:substitution_food, polymorphic: true, index: { name: 'index_substitutes_on_substitution_food' }
			t.text				:content
			t.text				:tags, array: true, default: []
			t.timestamps
		end
		add_column :foods, :keto_score, :integer, default: 0
		add_index :foods, :keto_score

	end
end
