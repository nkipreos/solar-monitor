class Account < ActiveRecord::Base
  has_many :user_account_relations
  has_many :users, through: :user_account_relations
end
