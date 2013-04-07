class Pioneer
  include Mongoid::Document
  include Mongo::Voteable
  include Mongoid::Timestamps

  belongs_to :user

  attr_accessible :img_id, :type, :approved, :approved_at

  field :img_id,      type: Integer
  field :type,        type: String   # vector, illustration, photo
  field :approved,    type: Boolean, default: false
  field :approved_at, type: Time,    default: Time.now
  field :user_name,   type: String

  validate :limit_num_of_pendings

  validates_inclusion_of :type, in: [ 'vector', 'illustration', 'photo' ], message: "Chose item type"
  validates_numericality_of :img_id, greater_than: 0,
                            message: 'ID should be number greater than 0'
  validates_uniqueness_of :img_id

  voteable self, :up => +1, :down => -1
  # voteable User, :up => +1, :down => -1

  # Tracker fields
  # field :album_id,    :type => Integer
  # field :other_imgs,  :type => Array # of Integer
  # field :submitted,   :type => Boolean

  def masked_id
    self.img_id.to_s[0...-3] << "***"
  end

  def limit_num_of_pendings
    pendings = Pioneer.where(:user_id => self.user_id,
                             :approved => false,
                             :type => self.type).count
    errors.add(:base, "You already has #{self.type} pending item") if pendings >= 1
  end

end
