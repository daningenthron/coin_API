# Preview all emails at http://localhost:3000/rails/mailers/admin_mailer/alert_email.html
class AdminMailerPreview < ActionMailer::Preview
  def alert_email
    AdminMailer.alert_email(Coin.first)
  end
end
