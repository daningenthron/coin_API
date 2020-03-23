class Coin < ApplicationRecord
  has_many :txns

  validates_presence_of :value
  validates :value, inclusion: { in: [1, 5, 10, 25],
                                 message: '%{value} is not a valid coin value' }
end
