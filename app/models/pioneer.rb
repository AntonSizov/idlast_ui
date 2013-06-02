class Pioneer
  include Mongoid::Document
  include Mongo::Voteable
  include Mongoid::Timestamps

  before_save :mask_id
  belongs_to :user

  attr_accessible :img_id, :type, :approved, :approved_at

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

  def predict_approved_datetime
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

  private

  def mask_id
    self.img_id = (self.img_id.to_s[0...-3] + "000").to_i
  end

end
