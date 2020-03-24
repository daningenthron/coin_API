class Txn < ApplicationRecord
  belongs_to :coin, optional: true
  belongs_to :api_key, optional: true

  validates_presence_of :value, :txn_type
  validates :txn_type, inclusion: { in: %w[deposit withdrawal],
                                message: 'Not a valid transaction type. Please choose deposit or withdrawal.' }
  validates :value, inclusion: { in: [1, 5, 10, 25],
                                 message: '%{value} is not a valid coin value.' }
  # validates :api_key, presence: true, api_key: true

  attr_accessor :api_key
end
