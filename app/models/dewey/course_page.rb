module Dewey
	class CoursePage < Pulitzer::Media

		include Dewey::CoursePageSearchable if (Dewey::CoursePageSearchable rescue nil)

		after_create :add_content_section

		belongs_to :parent, class_name: 'Dewey::Course'

		def course_id
			parent_id
		end

		def course
			parent
		end

		def page_meta
			super.merge( fb_type: 'article' )
		end


		private
			def add_content_section
				section = self.content_sections.create( name: "#{self.title}-main")
			end

	end
end
