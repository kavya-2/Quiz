class SubjectPerformanceService
	def self.calculate_subject_averages
		# Read the JSON data file
		responses_data = JSON.parse(File.read(Rails.root.join('public', 'responses.json')))
		questions_data = JSON.parse(File.read(Rails.root.join('public', 'questions.json')))

		subject_totals = Hash.new 
		subject_counts = Hash.new(0) 
		
		questions_data.each do |question| 
			question_id = question["id"]
			subject = question["subject"] 
			
			# Find the response for the current question ID
			response = responses_data.find { |r| r["question_id"] == question_id } 
			if response && response["correct"] 
				subject_totals[subject] += 1
			end 
			subject_counts[subject] += 1
		end

		subject_averages = {} 
		
		subject_counts.each do |subject, count| 
			subject_averages[subject] = (subject_totals[subject].to_f / count.to_f) * 100
		end

		subject_averages
	end
end