require 'rails_helper'
RSpec.describe AllStudentsController, type: :controller do
	describe 'GET /all_students/:quiz_type/:page' do 
		let(:quiz_type) { 'test' }
 		let(:page) { 1 } 
 		let(:per_page) { 2 } 
 		let(:quizzes_data) { [{'id': 1, 'quiz_type': 'test', 'completed': true, 'user_id': 1},
													{'id': 2, 'quiz_type': 'test', 'completed': true, 'user_id': 2}] } 
  	let(:responses_data) { [{'quiz_id': 1, 'correct': true}, {'quiz_id': 1, 'correct': false}, 
   												{'quiz_id': 2, 'correct': true}] }

		before do
		 allow(File).to receive(:read).with(any_args).and_call_original
    end

		it 'returns the paginated list of students with correct averages' do 
			allow(File).to receive(:read).with(Rails.root.join('public', 'quizzes.json')).and_return(quizzes_data.to_json) 
			allow(File).to receive(:read).with(Rails.root.join('public', 'responses.json')).and_return(responses_data.to_json) 

			get :index, params: { quiz_type: quiz_type, page: page }
			expect(response).to have_http_status(:success)
			parsed_response = JSON.parse(response.body)
			expect(parsed_response.length).to eq(per_page) 
			expect(parsed_response[0]['user_id']).to eq(1) 
			expect(parsed_response[0]['correct_average']).to eq(50.0) 
			expect(parsed_response[1]['user_id']).to eq(2)
			expect(parsed_response[1]['correct_average']).to eq(100.0) 
		end
  end

	describe 'GET /all_students/:quiz_type/:page' do 
		it 'returns the paginated users in JSON format' do
			paginated_users = [ 
				{
					'user_id' => 1, 
					'correct_average' => 63 
				},
				{
					'user_id' => 2, 
					'correct_average' => 90
				}
			]	

			allow(AllStudentsService).to receive(:all_students).and_return(paginated_users) 
			
			get :index, params: { quiz_type: 'test', page: 1 }

			expect(response).to have_http_status(:ok) 
			expect(JSON.parse(response.body)).to eq(paginated_users)
		end
	end
end