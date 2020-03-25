require 'rails_helper'

RSpec.describe AdminEmailJob, type: :job do
  describe "#perform" do
    let(:admin) { create(:admin) }

    it 'calls the alert email' do
      allow(Admin).to receive(:find).and_return(admin)
      allow(AdminMailer).to receive_message_chain(:alert_email, :deliver_now)

      described_class.new.perform(admin.id)

      expect(AdminMailer).to have_received(:alert_email)
    end
  end

  describe ".perform_later" do
    it "enqueues the job" do
      allow(AdminMailer).to receive_message_chain(:alert_email, :deliver_now)

      described_class.perform_later(1)

      expect(enqueued_jobs.last[:job]).to eq(described_class)
    end
  end
end
