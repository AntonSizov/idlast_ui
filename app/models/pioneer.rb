class Pioneer
  include Mongoid::Document
  belongs_to :user

  attr_accessible :img_id, :type, :approved, :approved_at

  field :img_id,      type: Integer
  field :type,        type: String   # vector, illustration, photo
  field :approved,    type: Boolean, default: false
  field :approved_at, type: Time,    default: Time.now
  field :user_name,   type: String
  field :created_at,  type: Time,    default: Time.now

  validates_numericality_of :img_id, greater_than: 0,
                            message: 'ID should be number greater than 0'
  validates_uniqueness_of :img_id

  # Tracker fields
  # field :album_id,    :type => Integer
  # field :other_imgs,  :type => Array # of Integer
  # field :submitted,   :type => Boolean

  def masked_id
    self.img_id.to_s[0...-3] << "***"
  end

end
