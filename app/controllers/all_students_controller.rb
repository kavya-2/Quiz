class AllStudentsController < ApplicationController
	def index
		students = AllStudentsService.all_students(params[:quiz_type], params[:page])
		render json: students
	end
end