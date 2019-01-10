
class BazaarMedia < ApplicationRecord
	include Bazaar::Concerns::MediaConcern
	include Bazaar::Concerns::MoneyAttributesConcern
	include BazaarMediaSearchable

	money_attributes :price, :suggested_price

	mounted_at '/shop'

	belongs_to :product, class_name: 'Bazaar::Product', required: false
	has_many_attached :gallery_attachments

	def suggested_price
		product.suggested_price
	end

	def price
		product.price
	end

end
