class SubjectPerformanceController < ApplicationController
	def index
		@subject_averages = SubjectPerformanceService.calculate_subject_averages
		render json: { subject_averages: @subject_averages }
	end
end