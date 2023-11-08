class ClassInformationService
  def self.class_information
		# Read the JSON data file
		users_data = JSON.parse(File.read(Rails.root.join('public', 'users.json')))
		quizzes_data = JSON.parse(File.read(Rails.root.join('public', 'quizzes.json')))
		responses_data = JSON.parse(File.read(Rails.root.join('public', 'responses.json')))
		
		# Calculate the overall class performance data
		all_users_average_test = calculate_average_for_quiz_type(quizzes_data, responses_data, 'test')
		all_users_average_practice = calculate_average_for_quiz_type(quizzes_data, responses_data, 'practice')
		total_quizzes_taken = quizzes_data.length
		total_responses = responses_data.length

		{
			all_users_average_test: all_users_average_test,
			all_users_average_practice: all_users_average_practice,
			total_quizzes_taken: total_quizzes_taken,
			total_responses: total_responses
		}
	end

	private
	def self.calculate_average_for_quiz_type(quizzes_data, responses_data, quiz_type)
		quiz_ids = quizzes_data.select { |quiz| quiz['quiz_type'] == quiz_type }.map { |quiz| quiz['id'] }

		user_responses = responses_data.select { |response| quiz_ids.include?(response['quiz_id']) }
		correct_responses = user_responses.count { |response| response['correct'] }

		(correct_responses.to_f / user_responses.length * 100).round(2)
	end
end