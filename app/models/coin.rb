class Coin < ApplicationRecord
  has_many :transactions

  validates_presence_of :value, :name
  validates :value, inclusion: { in: [1, 5, 10, 25],
                                 message: '%{value} is not a valid coin value' }

  def name_hash
    { 1 => 'penny', 5 => 'nickel', 10 => 'dime', 25 => 'quarter' }
  end

  def name(value)
    name_hash[value]
  end
end
