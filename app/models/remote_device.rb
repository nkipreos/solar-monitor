class RemoteDevice < ActiveRecord::Base
  belongs_to :account
  has_many :streams

  validates :name, :location_name, presence: true

  before_save :create_unique_id

  def create_unique_id
    self.unique_id = Digest::SHA256.hexdigest(UUID.generate)
  end

end
