class Stream < ActiveRecord::Base
  belongs_to :remote_device
  has_one :stream_data
end
