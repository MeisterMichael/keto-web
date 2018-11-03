
class Nutrient < ActiveRecord::Base
	include Pulitzer::Concerns::URLConcern

	attr_accessor	:slug_pref

	before_save :set_avatar
	before_save :set_defaults

	belongs_to :parent, class_name: 'Nutrient', required: false
	has_one_attached :avatar_attachment

	validates		:title, presence: true

	mounted_at '/nutrients'

	include FriendlyId
	friendly_id :slugger, use: [ :slugged, :history ]

	def self.find_or_create_by_title( title, args = {} )
		nutrient = Nutrient.where( "LOWER(title) = ?", title.downcase ).first
		nutrient ||= Nutrient.create( title: title )

		nutrient
	end

	def self.find_or_create_by_measurement( title, measurement, args = {} )

		nutrient = Nutrient.where( "LOWER(title) = ?", title.downcase ).first
		nutrient ||= Nutrient.create( title: title, daily_recommended_value: args[:daily_recommended_value] )

		nutrient
	end

	def slugger
		if self.slug_pref.present?
			self.slug = nil # friendly_id 5.0 only updates slug if slug field is nil
			return self.slug_pref
		else
			return self.title
		end
	end


	protected
		def set_avatar
			self.avatar = self.avatar_attachment.service_url if self.avatar_attachment.attached?
		end

		def set_defaults

			if self.title.downcase.start_with? 'net carbohydrates'
				self.calories_per_gram = 4
				self.daily_recommended_keto_value = (0.04 * 2000) / self.calories_per_gram
			end

			if self.title.downcase.start_with? 'total fat'
				self.calories_per_gram ||= 9
				self.daily_recommended_keto_value ||= (0.72 * 2000) / self.calories_per_gram
			end

			if self.title.downcase.start_with? 'protein'
				self.calories_per_gram ||= 4
				self.daily_recommended_keto_value ||= (0.24 * 2000) / self.calories_per_gram
			end
		end
end
