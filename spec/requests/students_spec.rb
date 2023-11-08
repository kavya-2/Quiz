require 'rails_helper'
RSpec.describe StudentsController, type: :controller do
	describe 'GET /all_students/:quiz_type' do 
		let(:quiz_type) { 'test' }
 		let(:page) { 1 } 
 		let(:per_page) { 10 } 
 		let(:quizzes_data) { [{'id': 1, 'quiz_type': 'test', 'completed': true, 'user_id': 1},
													{'id': 2, 'quiz_type': 'test', 'completed': true, 'user_id': 2}] } 
  	let(:responses_data) { [{'quiz_id': 1, 'correct': true}, {'quiz_id': 1, 'correct': false}, 
   												{'quiz_id': 2, 'correct': true}] }

		before do
     allow(File).to receive(:read).with(Rails.root.join('public', 'quizzes.json')).and_return(quizzes_data.to_json) 
     allow(File).to receive(:read).with(Rails.root.join('public', 'responses.json')).and_return(responses_data.to_json) 
		 allow(File).to receive(:read).with(any_args).and_call_original
    end

		it 'returns the paginated list of students with correct averages' do 
			get :all_students, params: { quiz_type: quiz_type, page: page }
			expect(response).to have_http_status(:success)
			parsed_response = JSON.parse(response.body)
			expect(parsed_response.length).to eq(per_page) 
			expect(parsed_response[0]['user_id']).to eq(983783) 
			expect(parsed_response[0]['correct_average']).to eq(72.0) 
			expect(parsed_response[1]['user_id']).to eq(983783)
			expect(parsed_response[1]['correct_average']).to eq(53.85) 
		end
  end
	
	describe 'GET /subject_performance/:subject' do 
		let(:users_data) do 	
			[ { 'id' => 1 }, { 'id' => 2 } ] 
		end 
		let(:quizzes_data) do 
			[ { 'id' => 1, 'user_id' => 1, 'completed' => true }, 
				{ 'id' => 2, 'user_id' => 2, 'completed' => false }, 
				{ 'id' => 3, 'user_id' => 1, 'completed' => true } 
			]
		end 
		let(:responses_data) do
			[ { 'quiz_id' => 1, 'question_id' => 1, 'correct' => true }, 
				{ 'quiz_id' => 2, 'question_id' => 2, 'correct' => true }, 
				{ 'quiz_id' => 3, 'question_id' => 1, 'correct' => false }, 
				{ 'quiz_id' => 3, 'question_id' => 2, 'correct' => true } 
			] 
		end 
		let(:questions_data) do 
			[ { 'id' => 1, 'subject' => 'biology' }, 
				{ 'id' => 2, 'subject' => 'nephrology' } 
			] 
		end 
		
		before do 
			allow_any_instance_of(File).to receive(:read).with(Rails.root.join('public', 'users.json')).and_return(users_data.to_json) 
			allow_any_instance_of(File).to receive(:read).with(Rails.root.join('public', 'quizzes.json')).and_return(quizzes_data.to_json) 
			allow_any_instance_of(File).to receive(:read).with(Rails.root.join('public', 'responses.json')).and_return(responses_data.to_json) 
			allow_any_instance_of(File).to receive(:read).with(Rails.root.join('public', 'questions.json')).and_return(questions_data.to_json) 
			allow_any_instance_of(File).to receive(:read).with(any_args).and_call_original
		end 
		
		it 'returns the subject performance' do 
			get :subject_performance, params: { subject: 'biology' } 
			
			expect(response).to have_http_status(:success) 
			json_response = JSON.parse(response.body) 
			expect(json_response['subject']).to eq('biology') 
			expect(json_response['correct_response_average']).to eq('57.78%') 
		end
	end

	describe 'GET #class_information' do
		let(:users_data) do 	
			[ { 'id' => 1 }, { 'id' => 2 } ] 
		end 
		let(:quizzes_data) do 
			[ { 'id' => 1, 'user_id' => 1, 'completed' => true }, 
				{ 'id' => 2, 'user_id' => 2, 'completed' => false }, 
				{ 'id' => 3, 'user_id' => 1, 'completed' => true } 
			]
		end 
		let(:responses_data) do
			[ { 'quiz_id' => 1, 'question_id' => 1, 'correct' => true }, 
				{ 'quiz_id' => 2, 'question_id' => 2, 'correct' => true }, 
				{ 'quiz_id' => 3, 'question_id' => 1, 'correct' => false }, 
				{ 'quiz_id' => 3, 'question_id' => 2, 'correct' => true } 
			] 
		end 

		before do 
			allow_any_instance_of(File).to receive(:read).with(Rails.root.join('public', 'users.json')).and_return(users_data.to_json) 
			allow_any_instance_of(File).to receive(:read).with(Rails.root.join('public', 'quizzes.json')).and_return(quizzes_data.to_json) 
			allow_any_instance_of(File).to receive(:read).with(Rails.root.join('public', 'responses.json')).and_return(responses_data.to_json) 
			allow_any_instance_of(File).to receive(:read).with(any_args).and_call_original
		end 

		it 'returns overall data for the class performance' do
			get :class_information
			expect(response).to have_http_status(:success)
			json_response = JSON.parse(response.body)
			expect(json_response['total_quizzes_taken']).to eq(246) 
			expect(json_response['total_responses']).to eq(7499)
		end
	end
end