class Response < ApplicationRecord
  belongs_to :question
  belongs_to :quiz
  validates :correct, inclusion: { in: [true, false] }
end
