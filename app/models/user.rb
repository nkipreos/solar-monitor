class User < ActiveRecord::Base
  has_many :user_account_relations
  has_many :accounts, through: :user_account_relations
end
