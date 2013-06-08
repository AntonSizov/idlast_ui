class Pioneer
  include Mongoid::Document
  include Mongo::Voteable
  include Mongoid::Timestamps

  before_save :mask_id
  belongs_to :user

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

  validates_inclusion_of :type, in: [ 'vector', 'illustration', 'photo' ], message: "Chose item type"
  validates_numericality_of :img_id, greater_than: 137000000,
                            message: 'ID should be number greater than 137000000'
  validates_uniqueness_of :img_id

  voteable self, :up => +1, :down => -1
  voteable User, :up => +1, :down => -1

  def masked_id
    self.img_id.to_s[0...-3] << "***"
  end

  def predict_approved_at
    return nil if self.type != 'vector'

    # this method implements simple y=kx+b expression
    last = Pioneer.where(approved: true, type: 'vector').order_by(img_id:-1).limit(1).to_a
    x1 = last[0].img_id
    y1 = last[0].approved_at.to_i

    first = Pioneer.where(approved: true, type: 'vector').order_by(img_id:-1).limit(1).skip(400).to_a
    x2 = first[0].img_id
    y2 = first[0].approved_at.to_i

    k = (y2 - y1).to_f / (x2 - x1).to_f
    b = y1 - k * x1

    predict_utc_timestamp = k * self.img_id + b

    return Time.at(predict_utc_timestamp)
  end

  def limit_num_of_pendings
    pendings = Pioneer.where(:user_id => self.user_id,
                             :approved => false,
                             :type => self.type)

    for pending in pendings do
      return true if pending.id == self.id
    end

    if pendings.length >= 1
      errors.add(:base, "You already has #{self.type} pending item")
    end

  end

  def uploaded_at_formatted
    return I18n.t(:unavailable) if self.user_name == 'IDLast.com'
    self.uploaded_at.to_s(:pioneer_datetime)
  end

  def approved_at_formatted
    self.approved_at.to_s(:pioneer_datetime)
  end

  def predict_approved_at_formatted
    self.predict_approved_at.to_s(:pioneer_datetime)
  end

  def on_the_road
    return I18n.t(:unavailable) if self.user_name == 'IDLast.com'
    return I18n.t(:unavailable) if !self.approved
    substraction = self.approved_at - self.uploaded_at
    return I18n.t(:unavailable) if substraction <= 0
    road_hash = time_length(substraction)
    return "#{road_hash[:days]} #{I18n.t(:on_the_road_days)} #{road_hash[:hours]} #{I18n.t(:on_the_road_hours)} #{road_hash[:minutes]} #{I18n.t(:on_the_road_minutes)}"
  end

  def works_before_approval
    last_approved = Pioneer.where(approved: true, type: self.type).order_by(img_id: -1).limit(1)
    self.img_id - last_approved[0].img_id
  end

  private

  def mask_id
    self.img_id = (self.img_id.to_s[0...-3] + "000").to_i
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
