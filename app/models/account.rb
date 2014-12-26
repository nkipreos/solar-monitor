class Account < ActiveRecord::Base
  has_many :user_account_relations
  has_many :users, through: :user_account_relations
  has_many :remote_devices

  validates :name, presence: true

  before_save :generate_api_key

  def generate_api_key
    self.api_key = Digest::SHA256.hexdigest(UUID.generate)
  end
end
