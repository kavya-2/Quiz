class Quiz < ApplicationRecord
  belongs_to :user
  has_many :questions
  has_many :responses
  validates :quiz_type, inclusion: { in: %w(practice test) }
end
