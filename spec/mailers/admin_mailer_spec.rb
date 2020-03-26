require 'rails_helper'
require 'pry'

RSpec.describe AdminMailer, type: :mailer do
  let(:admins) { create_list(:admin, 2) }
  let(:coin) { create(:coin, value: 5, name: "nickel") }
  let!(:bccs) { admins.map { |a| a.email } }
  let(:mail) { AdminMailer.alert_email(coin) }

  describe 'alert email' do
    context 'headers' do
      it 'renders the subject' do
        expect(mail.subject).to eq('Notice of coin shortage')
      end

      it 'sends to the correct email list' do        
      # binding.pry
        expect(mail.bcc).to eq(bccs)
      end

      it 'renders the from email' do
        expect(mail.from).to eq(['admin@coin-api.com'])
      end
    end

    it 'passes the correct coin' do
      expect(mail.body.encoded).to include('Nickels')
    end
  end
end
