
class Food < ActiveRecord::Base
	include Pulitzer::Concerns::URLConcern

	attr_accessor	:slug_pref, :category_name

	before_save	:set_publish_at
	before_save :set_avatar

	enum status: { 'draft' => 0, 'active' => 1, 'archive' => 2, 'trash' => 3 }

	has_many :food_nutrients, -> { joins(:nutrient).order('nutrients.position ASC, nutrients.id ASC') }
	has_many :nutrients, through: :food_nutrients
	has_many :food_measures

	has_one_attached :avatar_attachment
	has_one_attached :cover_attachment
	has_one_attached :nutrition_facts_attachment
	has_many_attached :embedded_attachments
	has_many_attached :other_attachments

	validates		:title, presence: true, unless: :allow_blank_title?

	mounted_at '/foods'

	include FriendlyId
	friendly_id :slugger, use: [ :slugged, :history ]

	acts_as_taggable_array_on :tags


	def self.media_tag_cloud( args = {} )
		args[:limit] ||= 7
		media_relation = self.limit(nil)
		return Food.unscoped.limit( args[:limit] ).tags_cloud{ merge( media_relation ) }.to_a
	end

	def parse_nutrient_facts
		nil
	end

	def parse_nutrient_facts=( nutrient_facts )
		self.food_nutrients.destroy_all
		list = self.food_nutrients.parse( nutrient_facts )
		list.each do |food_nutrient|
			self.food_nutrients << food_nutrient
		end
	end

	def self.published( args = {} )
		where( "publish_at <= :now", now: Time.zone.now ).active
	end

	def published?
		active? && publish_at < Time.zone.now
	end


	def sanitized_content
		ActionView::Base.full_sanitizer.sanitize( self.content )
	end

	def sanitized_description
		ActionView::Base.full_sanitizer.sanitize( self.description )
	end

	def slugger
		if self.slug_pref.present?
			self.slug = nil # friendly_id 5.0 only updates slug if slug field is nil
			return self.slug_pref
		else
			return self.title
		end
	end

	def tags_csv
		self.tags.join(',')
	end

	def tags_csv=(tags_csv)
		self.tags = tags_csv.split(/,\s*/)
	end

	def to_s
		self.title
	end


	protected
		def allow_blank_title?
			self.slug_pref.present?
		end


		def set_avatar
			self.avatar = self.avatar_attachment.service_url if self.avatar_attachment.attached?
			self.cover_image = self.cover_attachment.service_url if self.cover_attachment.attached?
		end

		def set_publish_at
			# set publish_at
			self.publish_at ||= Time.zone.now
		end
end
