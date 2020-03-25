require "rails_helper"

RSpec.describe AdminMailer, type: :mailer do
  let(:coin) { create(:coin, value: 5, name: "nickel") }
  let(:mail) { AdminMailer.alert_email(coin.name) }

  describe 'alert email' do
    context 'headers' do
      it 'renders the subject' do
        expect(mail.subject).to eq('Notice of coin shortage')
      end

      it 'sends to the correct email list' do
        expect(mail.to).to eq(Admin.pluck(:email))
      end

      it 'renders the from email' do
        expect(mail.from).to eq(['admin@coin-api.com'])
      end
    end

    it 'passes the correct coin' do
      expect(mail.body.encoded).to include('nickel')
    end
  end
end
