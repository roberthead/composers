class GoogleCount < ApplicationRecord
  belongs_to :composer

  validates :composer, presence: true
  validates :results_count, presence: true
  validates :results_count, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
