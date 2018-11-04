
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
		set_defaults
		if self.slug_pref.present?
			self.slug = nil # friendly_id 5.0 only updates slug if slug field is nil
			return self.slug_pref
		else
			return (self.fact_name || self.title)
		end
	end


	protected
		def set_avatar
			self.avatar = self.avatar_attachment.service_url if self.avatar_attachment.attached?
		end


		protected
		def set_defaults



			if self.title.downcase == 'Fatty acids, total saturated'.downcase
				self.fact_name ||= 'Saturated Fat'
			end

			if self.title.downcase == 'Fatty acids, total trans'.downcase
				self.fact_name ||= 'Trans Fat'
			end

			if self.title.downcase == 'Energy'.downcase
				self.fact_name ||= 'Calories'
			end

			if self.title.downcase == 'carbohydrate, by difference'.downcase
				self.fact_name ||= 'Total Carbohydrate'
			end

			if self.title.downcase == 'Fiber, total dietary'.downcase
				self.fact_name ||= 'Dietary Fiber'
			end

			if self.title.downcase == 'Sugars, total'.downcase
				self.fact_name ||= 'Total Sugars'
			end

			if self.title.downcase.start_with? 'net carbohydrates'
				self.fact_name ||= 'Net Carbohydrates'
				self.calories_per_unit = 4
				self.daily_recommended_keto_value = (0.04 * 2000) / self.calories_per_unit
			end

			if self.title.downcase.start_with?( 'total fat' ) || self.title.downcase.start_with?( 'total lipid (fat)' )
				self.fact_name ||= 'Total Fat'
				self.calories_per_unit ||= 9
				self.daily_recommended_keto_value ||= (0.72 * 2000) / self.calories_per_unit
			end

			if self.title.downcase.start_with? 'protein'
				self.fact_name ||= 'Protein'
				self.calories_per_unit ||= 4
				self.daily_recommended_keto_value ||= (0.24 * 2000) / self.calories_per_unit
			end

			self.fact_name ||= self.title
		end
end
