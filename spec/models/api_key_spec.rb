require 'rails_helper'

RSpec.describe ApiKey, type: :model do
  describe 'associations' do
    it { should have_many(:txns) }
  end

  describe 'validating email' do
    context 'presence' do
      it { should validate_presence_of(:email) }
    end

    context 'format' do
      it { should allow_value('email@example.com').for(:email) }
      it { should_not allow_value('not_an_email').for(:email) }
    end
  end
end
