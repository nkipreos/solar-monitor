class Stream < ActiveRecord::Base
  belongs_to :remote_device
  has_one :stream_data

  validates :name, :stream_type, presence: true

  before_save :create_unique_id

  def create_unique_id
    self.unique_id = Digest::SHA256.hexdigest(UUID.generate)
  end
  
end
