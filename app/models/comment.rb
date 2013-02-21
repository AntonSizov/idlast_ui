class Comment
  include Mongoid::Document
  embedded_in :article

  attr_accessible :content

  field :content,        :type => String, :default => ""
  field :user_id,        :type => Moped::BSON::ObjectId
  field :user_name,      :type => String
  field :created_at,     :type => Time, :default => Time.now

  def set_user user
    self.user_name = user.name
    self.user_id = user.id
  end

end
