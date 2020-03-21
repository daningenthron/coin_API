class Coin < ApplicationRecord
  has_many :transactions

  validates_presence_of :value, :name
end
