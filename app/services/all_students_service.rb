class AllStudentsService
	def self.all_students(quiz_type, page)
    # quiz_type = params[:quiz_type]
		page = page.to_i || 1
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

    {
      paginated_user:paginated_users, 
      page: page 
    }
		# paginated_users 
	end
end