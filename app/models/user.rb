class User < ActiveRecord::Base
  has_many :user_account_relations
  has_many :accounts, through: :user_account_relations
  
  has_secure_password

  validates :name, :email, :username, presence: true
  validates :email, :username, uniqueness: true

  before_validation :create_user_name

  def create_user_name
    self.username = email.split("@")[0]
  end
end
