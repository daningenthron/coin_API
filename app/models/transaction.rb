class Transaction < ApplicationRecord
  belongs_to :coin
  belongs_to :api_key

  validates_presence_of :type, :value
end
