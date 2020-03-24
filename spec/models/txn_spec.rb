require 'rails_helper'

RSpec.describe Txn, type: :model do
  describe 'associations' do
    # each transaction has a single coin and a single api key
    it { should belong_to(:coin).optional }
    it { should belong_to(:api_key).optional }
  end

  describe 'validations' do
    it { should validate_presence_of(:txn_type) }
    it { should validate_presence_of(:value) }
  end
end
