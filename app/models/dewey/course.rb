module Dewey
	class Course < ApplicationRecord
		include Dewey::Concerns::CourseConcern
		include Dewey::CourseSearchable if (Dewey::CourseSearchable rescue nil)
		mounted_at Dewey.courses_path

		has_many :course_pages, class_name: 'Dewey::CoursePage', foreign_key: :parent_id

	end

end
