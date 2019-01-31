class User < ApplicationRecord
	include Pulitzer::Concerns::URLConcern
	include SwellId::Concerns::UserConcern
	include UserSearchable

	enum status: { 'trash' => -50, 'revoked' =>- 20, 'active' => 1  }
	enum role: { 'member' => 1, 'contributor' => 20, 'admin' => 30 }

	mounted_at '/u'

	devise 		:database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :authentication_keys => [:login]

	before_save		:set_avatar

	has_one_attached :avatar_attachment

	has_many :enrollments, class_name: 'Dewey::Enrollment'
	has_many :enrollment_lessons, class_name: 'Dewey::EnrollmentLesson', through: :enrollments
	has_many :posts, class_name: 'Scuttlebutt::Post'

	### VALIDATIONS	---------------------------------------------
	validates_uniqueness_of		:username, case_sensitive: false, allow_blank: true, if: Proc.new{ |u| u.username_changed? && u.registered? }
	validates_presence_of 		:email
	validates_uniqueness_of		:email, case_sensitive: false, if: :email_changed?
	validates_format_of			:email, with: Devise.email_regexp, if: :email_changed?

	validates_confirmation_of	:password, if: [ :encrypted_password_changed?, :registered? ]
	validates_length_of			:password, within: Devise.password_length, allow_blank: true, if: Proc.new{ |u| u.encrypted_password_changed? && u.registered? }

	def page_meta
		title = "#{self.username} | #{Pulitzer.app_name}"

		{
			page_title: title,
			title: self.username,
			# description: self.sanitized_description,
			image: self.avatar,
			url: self.url,
			# twitter_format: 'summary_large_image',
			# type: 'article',
			# og: {
			# 	"article:published_time" => self.publish_at.iso8601,
			# 	"article:author" => self.user.to_s
			# },
			# data: {
			# 	'url' => @user.url,
			# 	'name' => self.title,
			# 	'description' => self.sanitized_description,
			# 	'datePublished' => self.publish_at.iso8601,
			# 	'author' => self.user.to_s,
			# 	'image' => self.avatar
			# }
		}
	end

	def self.find_for_database_authentication(warden_conditions)
		conditions = warden_conditions.dup
		if login = conditions.delete(:login)
			where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
		elsif conditions.has_key?(:username) || conditions.has_key?(:email)
			where(conditions.to_h).first
		end
	end

	def self.term_search( term )
		users = self
		if term.present?
			query = "%#{term.gsub('%','\\\\%')}%"
			users = users.where( "username ILIKE :q OR (first_name || ' ' || last_name) ILIKE :q OR email ILIKE :q OR phone ILIKE :q", q: query )
		end
		users
	end

	protected

		def set_avatar
			if self.avatar_attachment.attached?
				self.avatar = self.avatar_attachment.service_url
			else
				self.avatar = "https://gravatar.com/avatar/" + Digest::MD5.hexdigest( self.email ) + "?d=retro&s=200"
			end

		end

end
