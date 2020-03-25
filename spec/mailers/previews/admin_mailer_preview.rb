# Preview all emails at http://localhost:3000/rails/mailers/admin_mailer
class AdminMailerPreview < ActionMailer::Preview
  def alert_email
    AdminMailer.alert_email(admin: Admin.first, coin: Coin.first.name)
  end
end
