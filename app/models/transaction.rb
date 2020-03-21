class Transaction < ApplicationRecord
  belongs_to :coin
  belongs_to :apikey
end
