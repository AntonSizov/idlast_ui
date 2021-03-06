class User

  include Mongoid::Document
  include Mongo::Voteable
  include Mongo::Voter
  include Mongoid::Timestamps

  MAX_PENDING_ITEMS_PER_TYPE = 1

  has_many :articles
  has_many :pioneers

  scope :admins, where(admin: true)
  scope :sorted_by_created_at, order_by(created_at: -1)

  after_create :notify_new_user

  attr_accessible :name, :email, :password
  attr_readonly :admin

  validates_uniqueness_of :name, case_sensitive: false
  validates_length_of :name, minimum: 3, maximum: 20
  validates_presence_of :name

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  ## Database authenticatable
  field :name,               type: String
  field :admin,              type: Boolean, default: false
  field :timezone,           type: String
  field :articles_notify,    type: Boolean, default: true
  field :email,              type: String
  field :encrypted_password, type: String

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  ## Confirmable
  # field :confirmation_token,   :type => String
  # field :confirmed_at,         :type => Time
  # field :confirmation_sent_at, :type => Time
  # field :unconfirmed_email,    :type => String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  # field :locked_at,       :type => Time

  ## Token authenticatable
  # field :authentication_token, :type => String

  def can_add_pioneer? type
    pendings = self.pioneers.pendings_of_type(type).count
    return false if pendings >= MAX_PENDING_ITEMS_PER_TYPE
    return true
  end

  def can_add_pioneers?
    pendings = self.pioneers.pending.count
    if pendings >= (MAX_PENDING_ITEMS_PER_TYPE * 3)
      return false
    else
      return true
    end
  end

  def timezone_presented?
    return false if !self.timezone
    true
  end

  private

  def notify_new_user
    UserMailer.new_user_notify(self).deliver
  end

end
