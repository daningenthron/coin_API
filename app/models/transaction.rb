class Transaction < ApplicationRecord
  belongs_to :coin
  belongs_to :api_key

  validates_presence_of :value, :type
  validates :type, inclusion: { in: [deposit, withdrawal],
                                message: '%{value} is not a valid transaction' }
end
