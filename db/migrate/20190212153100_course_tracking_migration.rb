class CourseTrackingMigration < ActiveRecord::Migration[5.1]

	def change

		create_table :dewey_enrollment_course_pages do |t|
			t.belongs_to	:enrollment
			t.belongs_to	:course_page
			t.integer			:status,       default: 1
			t.timestamps
		end

	end
end
