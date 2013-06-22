class Comment
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :article

  attr_accessible :content

  field :content,        type: String
  field :user_id,        type: Moped::BSON::ObjectId
  field :user_name,      type: String
  field :user_email,     type: String

  after_create :notify_new_comment

  validates_length_of :content, minimum: 1, maximum: 1000

  def set_user user
    self.user_name = user.name
    self.user_id = user.id
    self.user_email = user.email
  end

  private

  def notify_new_comment
    CommentMailer.new_comment_notify(self).deliver
  end

end
