require 'rails_helper'

RSpec.describe Coin, type: :model do
  describe 'associations' do
    it { should have_many(:transactions) }
  end

  describe 'validations' do
    it { should validate_presence_of(:value) }
    it { should validate_presence_of(:name) }
  end
end
