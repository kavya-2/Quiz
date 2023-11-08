class User < ApplicationRecord
	has_many :quizzes
	validates :first_name, :last_name, :email, presence: true
end
