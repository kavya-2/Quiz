class ClassInformationController < ApplicationController
	def index
		class_info = ClassInformationService.class_information
		render json: class_info
	end
end