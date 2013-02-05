class Subscription
  include Mongoid::Document
  belongs_to :user

  field :pioneer_id, :type => Integer
  field :notify,     :type => Integer
  field :email,      :type => String
  field :user_name,  :type => String
  field :submitted,  :type => Boolean, :default => false
  field :created_at, :type => Time, :default => Time.now

  validates_presence_of :pioneer_id
  validates_presence_of :notify
  validates_presence_of :email
  validates_presence_of :user_name

  validates_uniqueness_of :pioneer_id

  validates_numericality_of :pioneer_id, greater_than: 0
  validates_numericality_of :notify, greater_than: 0

  attr_accessible :pioneer_id, :notify

end
