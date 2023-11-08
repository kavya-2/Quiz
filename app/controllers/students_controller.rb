class StudentsController < ApplicationController
	# include Paginatable
	def all_students
		quiz_type = params[:quiz_type]
    page = params[:page].to_i || 1
    per_page = 10

		# Read the JSON data file
		quizzes_data = JSON.parse(File.read(Rails.root.join('public', 'quizzes.json')))
		responses_data = JSON.parse(File.read(Rails.root.join('public', 'responses.json')))

		# Filter the quizzes by the quiz type
    quizzes_filtered = quizzes_data.select { |quiz| quiz['quiz_type'] == quiz_type && quiz['completed'] == true }

		# Calculate the correct response average for each user
		user_averages = quizzes_filtered.map do |quiz|
			user_responses = responses_data.select { |response| quiz['id'] == response['quiz_id'] }
      correct_responses = user_responses.count { |response| response['correct'] }
      {
        user_id: quiz['user_id'],
        correct_average: (correct_responses.to_f / user_responses.length * 100).round(2)
      }
		end

		# Paginate the user records
		start_index = (page - 1) * per_page
		puts start_index
    end_index = start_index + per_page - 1
		puts end_index
    # paginated_users = user_averages.uniq[start_index..end_index].map { |user| user[:user_id] } #-10 -1
		paginated_users = user_averages[start_index..end_index]

		# Return the paginated JSON response
    render json: paginated_users
	end
		
	def subject_performance 
		subject = params[:subject]

		# Read the JSON data file
		users_data = JSON.parse(File.read(Rails.root.join('public', 'users.json')))
		quizzes_data = JSON.parse(File.read(Rails.root.join('public', 'quizzes.json')))
		responses_data = JSON.parse(File.read(Rails.root.join('public', 'responses.json')))
		questions_data = JSON.parse(File.read(Rails.root.join('public', 'questions.json')))
		
		user_responses = responses_data.select do |response| 
			user = users_data.find { |user| user['id'] == quizzes_data.find { |quiz| quiz['id'] == response['quiz_id'] } ['user_id'] }
			quiz = quizzes_data.find { |quiz| quiz['id'] == response['quiz_id'] }
			question = questions_data.find { |question| question['id'] == response['question_id'] } 
			
			quiz['completed'] && question['subject'] == subject && response['correct']
			# total_user_responses = quiz['completed'] && question['subject'] == subject 
		end

		total_user_responses = responses_data.select do |response| 
			user = users_data.find { |user| user['id'] == quizzes_data.find { |quiz| quiz['id'] == response['quiz_id'] } ['user_id'] }
			quiz = quizzes_data.find { |quiz| quiz['id'] == response['quiz_id'] }
			question = questions_data.find { |question| question['id'] == response['question_id'] } 
			
			quiz['completed'] && question['subject'] == subject 
		end 

		user_response_count = user_responses.length
		total_user_responses_count = total_user_responses.length
		
		if user_response_count.zero? || total_user_responses_count.zero?
			average_correct_response = 0
		else 
			average_correct_response = (user_response_count.to_f / total_user_responses_count.to_f) * 100
		end 
		
		json_response = { 
			subject: subject, 
			correct_response_average: "#{average_correct_response.round(2)}%", 
			user_id: user_responses.map { |response| quizzes_data.find { |quiz| quiz['id'] == response['quiz_id'] } ['user_id'] }.uniq 
		}
		render json: json_response 
	end

	def class_information
		# Read the JSON data file
		users_data = JSON.parse(File.read(Rails.root.join('public', 'users.json')))
		quizzes_data = JSON.parse(File.read(Rails.root.join('public', 'quizzes.json')))
		responses_data = JSON.parse(File.read(Rails.root.join('public', 'responses.json')))
		
		# Calculate the overall class performance data
    all_users_average_test = calculate_average_for_quiz_type(quizzes_data, responses_data, 'test')
    all_users_average_practice = calculate_average_for_quiz_type(quizzes_data, responses_data, 'practice')
    total_quizzes_taken = quizzes_data.length
    total_responses = responses_data.length

		# Return the JSON response
    render json: {
			all_users_average_test: all_users_average_test,
			all_users_average_practice: all_users_average_practice,
			total_quizzes_taken: total_quizzes_taken,
			total_responses: total_responses
    }
	end

	private
	def calculate_average_for_quiz_type(quizzes_data, responses_data, quiz_type)
    quiz_ids = quizzes_data.select { |quiz| quiz['quiz_type'] == quiz_type }.map { |quiz| quiz['id'] }

		user_responses = responses_data.select { |response| quiz_ids.include?(response['quiz_id']) }
    correct_responses = user_responses.count { |response| response['correct'] }

    (correct_responses.to_f / user_responses.length * 100).round(2)
	end
end

