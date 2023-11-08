# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

User.destroy_all

users = [
	{ first_name: "John", last_name: "Doe", email: "john.doe@example.com", sign_up_date: Date.today - 30 },
	{ first_name: "Jane", last_name: "Doe", email: "jane.doe@example.com", sign_up_date: Date.today - 15 },
	{ first_name: "Bob", last_name: "Smith", email: "bob.smith@example.com", sign_up_date: Date.today - 10 }
]

users.each do |user_data|
	user = User.create!(user_data)
	quiz = Quiz.create!(quiz_type: "test", completed: true, user: user)
	question1 = Question.create!(text: "What is 2+2?", subject: "Math", correct_answer: "4", quiz: quiz)
	response1 = Response.create!(correct: true, question: question1, quiz: quiz)
	question2 = Question.create!(text: "What is the capital of France?", subject: "Geography", correct_answer: "Paris", quiz: quiz)
	response2 = Response.create!(correct: false, question: question2, quiz: quiz)
end