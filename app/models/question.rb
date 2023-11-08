class Question < ApplicationRecord
  belongs_to :quiz
  validates :text, :subject, :correct_answer, presence: true
end
