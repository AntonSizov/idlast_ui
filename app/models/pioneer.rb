class Pioneer
  include Mongoid::Document
  include Mongo::Voteable
  include Mongoid::Timestamps

  IDLAST_USER_NAME = 'IDLast.com'

  before_save :mask_id
  belongs_to :user

  scope :pending, where(approved: false)
  scope :approved, where(approved: true)
  scope :sorted_by_img_id, order_by(img_id: -1)

  scope :approved_sorted_by_img_id, approved.sorted_by_img_id

  scope :vectors, where(type: 'vector')
  scope :approved_vectors, vectors.approved
  scope :approved_vectors_sorted_by_img_id, approved_vectors.sorted_by_img_id

  scope :illustrations, where(type: 'illustration')
  scope :approved_illustrations, illustrations.approved
  scope :approved_illustrations_sorted_by_img_id, approved_illustrations.sorted_by_img_id

  scope :photos, where(type: 'photo')
  scope :approved_photos, photos.approved
  scope :approved_photos_sorted_by_img_id, approved_photos.sorted_by_img_id

  scope :of_type, ->(type){ where(type: type) }
  scope :approved_of_type, ->(type){ approved.of_type(type) }
  scope :pendings_of_type, ->(type){ pending.of_type(type) }
  scope :last_approved_of_type, ->(type){ approved_sorted_by_img_id.of_type(type).limit(1) }

  scope :of_user, ->(user_id){ where(user_id: user_id) }

  scope :users, where(:user_name.ne => IDLAST_USER_NAME)
  scope :users_pending_sorted_by_created_at, users.pending.order_by(created_at: -1)

  attr_accessible :img_id, :type, :approved, :approved_at, :uploaded_at

  field :img_id,      type: Integer
  field :type,        type: String
  field :approved,    type: Boolean, default: false
  field :approved_at, type: Time
  field :uploaded_at, type: Time,    default: ->{ Time.now }
  field :user_name,   type: String
  field :user_email,  type: String
  field :submitted,   type: Boolean, default: false

  validate :limit_num_of_pendings
  validate :uploaded_at_should_be_less_than_approved_at

  validates_inclusion_of :type, in: [ 'vector', 'illustration', 'photo' ],
                          message: I18n.t(:chose_proper_pioneer_type)
  validates_numericality_of :img_id, greater_than: 140000000, less_than: 400000000,
                            message: I18n.t(:img_id_validation)
  validates_uniqueness_of :img_id

  voteable self, up: +1, down: -1
  voteable User, up: +1, down: -1

  def masked_id
    self.img_id.to_s[0...-3] << '***'
  end

  def predict_approved_at
    return nil if self.type != 'vector'

    # this method implements simple y=kx+b expression
    last = Pioneer.approved_vectors_sorted_by_img_id.first
    x1 = last.img_id
    y1 = last.approved_at.to_i

    first = Pioneer.approved_vectors_sorted_by_img_id.skip(400).first
    x2 = first.img_id
    y2 = first.approved_at.to_i

    k = (y2 - y1).to_f / (x2 - x1).to_f
    b = y1 - k * x1

    predict_utc_timestamp = k * self.img_id + b

    return Time.at(predict_utc_timestamp)
  end

  def uploaded_at_formatted
    return I18n.t(:unavailable) if self.user_name == IDLAST_USER_NAME
    self.uploaded_at.to_s(:pioneer_datetime)
  end

  def approved_at_formatted
    self.approved_at.to_s(:pioneer_datetime)
  end

  def predict_approved_at_formatted
    self.predict_approved_at.to_s(:pioneer_datetime)
  end

  def on_the_road
    return I18n.t(:unavailable) if self.user_name == IDLAST_USER_NAME
    return I18n.t(:unavailable) if !self.approved
    substraction = self.approved_at - self.uploaded_at
    return I18n.t(:unavailable) if substraction <= 0
    road_hash = time_length(substraction)
    return "#{road_hash[:days]} #{I18n.t(:on_the_road_days)} #{road_hash[:hours]} #{I18n.t(:on_the_road_hours)} #{road_hash[:minutes]} #{I18n.t(:on_the_road_minutes)}"
  end

  def works_before_approval
    last_approved = Pioneer.last_approved_of_type(self.type).first
    return self.img_id - last_approved.img_id
  end

  def probably_approved?
    return false if self.approved
    last_approved = Pioneer.last_approved_of_type(self.type).first
    return true if self.img_id < last_approved.img_id
    return false
  end

  def pending?
    !self.approved?
  end

  def share_text
    substraction = self.approved_at - self.uploaded_at
    return nil if substraction <= 0
    road_hash = time_length(substraction)
    "#{self.masked_id} #{I18n.t(self.type)}<br />#{self.uploaded_at_formatted} - #{self.approved_at_formatted}<br />#{I18n.t(:on_the_road)}#{road_hash[:days]} #{I18n.t(:on_the_road_days)} #{road_hash[:hours]} #{I18n.t(:on_the_road_hours)}<br />#{I18n.t(:generated_by_idlast)}"
  end

  def voteble?
   return true if self.approved && (self.approved_at > 1.day.ago)
   false
  end

  private

  def limit_num_of_pendings
    pendings = self.user.pioneers.pendings_of_type(self.type)
    for pending in pendings do
      return true if pending.id == self.id
    end

    if pendings.length >= 1
      errors.add(:base, "You already have #{self.type} pending item")
    end

  end

  def uploaded_at_should_be_less_than_approved_at
    if self.approved? and (self.approved_at < self.uploaded_at)
      errors.add(:base, I18n.t(:uploaded_at_should_be_less_than_approved_at))
    end
  end

  def mask_id
    self.img_id = (self.img_id.to_s[0...-3] + '000').to_i
  end

  def time_length seconds
    days = (seconds / 1.day).floor
    seconds -= days.days
    hours = (seconds / 1.hour).floor
    seconds -= hours.hours
    minutes = (seconds / 1.minute).floor
    seconds -= minutes.minutes
    { days: days, hours: hours, minutes: minutes, seconds: seconds }
  end

end
