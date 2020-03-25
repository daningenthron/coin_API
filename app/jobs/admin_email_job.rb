class AdminEmailJob < ApplicationJob
  queue_as :alert_emails

  def perform(coin)
    AdminMailer.alert_email(coin).deliver_now
  end
end
