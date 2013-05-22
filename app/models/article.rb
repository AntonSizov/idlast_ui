class Article
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :user
  embeds_many :comments

  attr_accessible :title, :text, :published

  field :title,             :type => String, :default => ""
  field :text,              :type => String, :default => ""
  field :user_name,         :type => String, :default => ""
  field :published,         :type => Boolean, :default => false
  field :submitted,         :type => Boolean, :default => false

end
