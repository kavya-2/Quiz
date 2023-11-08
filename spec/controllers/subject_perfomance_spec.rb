require 'rails_helper'
RSpec.describe SubjectPerformanceController, type: :controller do
	describe 'GET #index' do 
		it 'returns the subject averages in JSON format' do
			subject_averages = { 
				'Biology' => 80, 
				'Medicine' => 90 
			}

			allow(SubjectPerformanceService).to receive(:calculate_subject_averages).and_return(subject_averages) 
			
			get :index 

			expect(response).to have_http_status(:ok) 
			expect(JSON.parse(response.body)['subject_averages']).to eq(subject_averages)
		end
	end
end