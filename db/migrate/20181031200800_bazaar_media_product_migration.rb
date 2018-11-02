class BazaarMediaProductMigration < ActiveRecord::Migration[5.1]

	def change

		add_column :bazaar_media, :short_description, :text, default: nil
		add_column :bazaar_media, :data_sheet, :text, default: nil
		add_column :bazaar_media, :product_id, :integer, default: nil

	end

end
