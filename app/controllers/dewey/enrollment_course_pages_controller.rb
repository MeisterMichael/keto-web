module Dewey

	class EnrollmentCoursePagesController < ApplicationController

		def create

			@enrollment_course_page = Dewey::EnrollmentCoursePage.create_with( status: 'completed' ).where( params.require(:enrollment_course_page).permit(:enrollment_id,:course_page_id) ).first_or_create
			@enrollment_course_page.completed!


			@course = @enrollment_course_page.course_page.root.course
			@enrollment = @enrollment_course_page.enrollment

			other_course_pages = @course.course_page.descendants.publish_at_before_now.active.where.not( id: @enrollment_course_page.course_page.id )

			if params[:direction] == 'previous'
				@redirect_course_page = other_course_pages.where( lft: 0..@enrollment_course_page.course_page.left ).order(lft: :desc).first
			else
				@redirect_course_page = other_course_pages.where.not( lft: 0..@enrollment_course_page.course_page.left ).order(lft: :asc).first
			end

			if @redirect_course_page.present?
				redirect_to enrollment_course_page_path( @redirect_course_page.id, enrollment_id: @enrollment.id )
			else
				redirect_to enrollment_path( @enrollment.id )
			end

		end

		def next_lecture
			@enrollment = current_user.enrollments.find( params[:enrollment_id] )
			@course = @enrollment.course
			@enrollment_course_pages = Dewey::EnrollmentCoursePage.completed.where( enrollment: @enrollment )

			course_pages = @course.course_page.descendants.publish_at_before_now.active

			@redirect_course_page = course_pages.where.not( id: @enrollment_course_pages.select(:course_page_id) ).first
			@redirect_course_page ||= @enrollment_course_pages.order( updated_at: :desc ).first.course_page

			redirect_to enrollment_course_page_path( @redirect_course_page.id, enrollment_id: @enrollment.id )
		end

	end

end
