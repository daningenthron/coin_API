class Coin < ApplicationRecord

  has_many :txns

  validates_presence_of :value
  validates :value, inclusion: { in: [1, 5, 10, 25],
                                 message: '%{value} is not a valid coin value' }

  def self.name_hash
    { 1 => 'penny', 5 => 'nickel', 10 => 'dime', 25 => 'quarter' }
  end

  def self.coin_name(params)
    name_hash[params[:value].to_i]
  end

  def self.total
    self.sum(:value)
  end
end
