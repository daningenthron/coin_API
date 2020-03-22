class Transaction < ApplicationRecord
  belongs_to :coin
  belongs_to :api_key

  validates_presence_of :value, :type
  validates :type, inclusion: { in: %w[deposit withdrawal],
                                message: 'Not a valid transaction type. Please choose deposit or withdrawal.' }
  validates :value, inclusion: { in: [1, 5, 10, 25],
                                 message: '%{value} is not a valid coin value.' }
end
