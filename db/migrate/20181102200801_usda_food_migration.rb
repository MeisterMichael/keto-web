class UsdaFoodMigration < ActiveRecord::Migration[5.1]

	def change

		add_column :foods, :usda_ndbno, :string, default: nil
		add_column :foods, :properties, :hstore, default: {}

	end

end
