class AdminMailer < ApplicationMailer
  default from: 'admin@coin-api.com',
          to: 'admin@coin-api.com',
          bcc: -> { Admin.pluck(:email) }

  def alert_email(coin)
    @coin = coin
    mail(subject: 'Notice of coin shortage')
  end
end
