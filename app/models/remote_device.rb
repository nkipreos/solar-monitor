class RemoteDevice < ActiveRecord::Base
  belongs_to :account
  has_many :streams
end
