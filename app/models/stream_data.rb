class StreamData < ActiveRecord::Base
  belongs_to :stream

  validates :value, presence: true
end
