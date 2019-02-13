module Dewey

	class EnrollmentCoursePage < ActiveRecord::Base

		belongs_to :enrollment, class_name: 'Dewey::Enrollment'
		belongs_to :course_page, class_name: 'Dewey::CoursePage'

		enum status: { 'started' => 1, 'completed' => 100 }

	end

end
