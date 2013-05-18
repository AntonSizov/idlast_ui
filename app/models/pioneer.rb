class Pioneer
  include Mongoid::Document
  include Mongo::Voteable
  include Mongoid::Timestamps

  belongs_to :user

  attr_accessible :img_id, :type, :approved, :approved_at

  field :img_id,      type: Integer
  field :type,        type: String
  field :approved,    type: Boolean, default: false
  field :approved_at, type: Time,    default: ->{ Time.now.utc }
  field :user_name,   type: String
  field :user_email,  type: String
  field :submitted,   type: Boolean, default: false

  validate :limit_num_of_pendings

  validates_inclusion_of :type, in: [ 'vector', 'illustration', 'photo' ], message: "Chose item type"
  validates_numericality_of :img_id, greater_than: 0,
                            message: 'ID should be number greater than 0'
  validates_uniqueness_of :img_id

  voteable self, :up => +1, :down => -1
  voteable User, :up => +1, :down => -1

  def masked_id
    self.img_id.to_s[0...-3] << "***"
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

end
