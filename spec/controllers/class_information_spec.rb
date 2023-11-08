require 'rails_helper'
RSpec.describe ClassInformationController, type: :controller do
	describe 'GET class_information#index' do
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
			allow(File).to receive(:read).with(any_args).and_call_original
		end 

		it 'returns overall data for the class performance' do
			allow(File).to receive(:read).with(Rails.root.join('public', 'users.json')).and_return(users_data.to_json) 
			allow(File).to receive(:read).with(Rails.root.join('public', 'quizzes.json')).and_return(quizzes_data.to_json) 
			allow(File).to receive(:read).with(Rails.root.join('public', 'responses.json')).and_return(responses_data.to_json) 

			get :index

			expect(response).to have_http_status(:success)
			json_response = JSON.parse(response.body)
			expect(json_response['total_quizzes_taken']).to eq(3) 
			expect(json_response['total_responses']).to eq(4)
		end
	end

	describe 'GET #index' do 
		it 'returns the class performance in JSON format' do
			class_info = { 
				'all_users_average_test' => 60.81,
				'all_users_average_practice' => 60.56,
				'total_quizzes_taken' => 246,
				'total_responses' => 7499
			}

			allow(ClassInformationService).to receive(:class_information).and_return(class_info) 
			
			get :index 

			expect(response).to have_http_status(:ok) 
			expect(JSON.parse(response.body)).to eq(class_info)
		end
	end
end