module Dewey

	class CoursePagesController < RootController
		include Dewey::Concerns::DeweyConcern

		def pulitzer_render(media)

			@course = media.root.course
			@enrollment = current_user.enrollments.find( params[:enrollment_id] ) if params[:enrollment_id]
			# @previous_course_pages = @course.course_page.descendants.publish_at_before_now.active.where.not( lft: media.left ).where( lft: 0..media.left ).order(lft: :desc)
			# @next_course_pages = @course.course_page.descendants.publish_at_before_now.active.where.not( lft: media.left ).where.not( lft: 0..media.left ).order(lft: :asc)

			@enrollment_course_page = Dewey::EnrollmentCoursePage.create_with( status: 'started' ).where( enrollment_id: @enrollment.id, course_page_id: media.id ).first_or_create
			@enrollment_course_page.touch

			super(media)
		end

	end
end
