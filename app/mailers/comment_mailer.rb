class CommentMailer < ActionMailer::Base
  default to: User.admins.map(&:email),
    from: "no-reply@idlast.com"

  def new_comment_notify(comment)
    @comment = comment
    mail(subject: 'New comment')
  end

end
