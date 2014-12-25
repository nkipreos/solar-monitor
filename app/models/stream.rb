class Stream < ActiveRecord::Base
  belongs_to :remote_device
  has_many :stream_data
end
