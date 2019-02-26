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


			if media.content.try(:strip).blank?

				@enrollment_course_page.completed!

				other_course_pages = @course.course_page.descendants.publish_at_before_now.active.where.not( id: @enrollment_course_page.course_page.id )
				@redirect_course_page = other_course_pages.where.not( lft: 0..@enrollment_course_page.course_page.left ).order(lft: :asc).first

				if @redirect_course_page.present?
					redirect_to enrollment_course_page_path( @redirect_course_page.id, enrollment_id: @enrollment.id )
				else
					redirect_to enrollment_path( @enrollment.id )
				end

				return false
			end

			super(media)
		end

	end
end
