class UserMailer < ApplicationMailer
  def created(user)
    @user = user
    mail to: user.email, subject: 'Welcome', body: 'Welcome'
  end
end
