class Article
  include Mongoid::Document
  belongs_to :user

  attr_accessible :title, :text, :published

  field :title,             :type => String, :default => ""
  field :text,              :type => String, :default => ""
  field :user_name,         :type => String, :default => ""
  field :published,         :type => Boolean, :default => false
  field :created_at,        :type => Time, :default => Time.now

end
