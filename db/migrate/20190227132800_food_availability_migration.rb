class FoodAvailabilityMigration < ActiveRecord::Migration[5.1]

	def change

		add_column :foods, :availability, :integer, default: 1
		add_index :foods, [:availability,:status,:publish_at]

	end
end
