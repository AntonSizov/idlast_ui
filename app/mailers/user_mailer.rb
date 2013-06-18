class UserMailer < ActionMailer::Base
  default to: User.admins.map(&:email),
    from: "no-reply@idlast.com"

  def new_user_notify(user)
    @user = user
    mail(subject: 'New user registered')
  end

end
