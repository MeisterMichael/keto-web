module Scuttlebutt
	module DiscussionTopicSearchable
		extend ActiveSupport::Concern

		included do
			include Searchable

			settings index: { number_of_shards: 1 } do
				mappings dynamic: 'false' do
					indexes :id, type: 'integer'
					indexes :created_at, type: 'date'
					indexes :subject, analyzer: 'english', index_options: 'offsets'
					indexes :content, analyzer: 'english', index_options: 'offsets'
					indexes :rating, type: 'integer'
					indexes :status
					indexes :public, type: 'boolean'
					indexes :full_text, analyzer: 'english', index_options: 'offsets'
				end
			end
		end

		module ClassMethods
			# def class_method_name ... end
		end

		# Instance Methods
		# def instance_method_name ... end
		def as_indexed_json(options={})
			full_text = self.content
			full_text = "#{full_text}\n#{self.posts.collect{|post| post.content }.join("\n")}"

			as_json().merge( 'public' => (self.anyone? && self.active?), full_text: full_text )
		end

	end

end
