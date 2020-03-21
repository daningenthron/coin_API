class ApiKey < ApplicationRecord
  has_many :transactions

  validates_presence_of :email
end
