class DashboardController < ApplicationController

  def show
    @remote_devices = []
    @streams = []
    @data_x = []
    @data_y =[]
    @current_user.accounts.each do |account|
      account.remote_devices.each do |remote_device|
        @remote_devices << remote_device
      end
    end
    @remote_devices.each do |remote_device|
      remote_device.streams.each do |stream|
        @streams << stream
      end
    end
    @streams.each_with_index do |stream, index|
      @data_x[index] = []
      @data_y[index] = []
      @data_x[index] << 'x'
      @data_y[index] << stream.name
      last_data = StreamData.where(:stream_id => stream.id).last.nil? ? Time.now : StreamData.where(:stream_id => stream.id).last.measured_at
      StreamData.where(:stream_id => stream.id).where(:measured_at => (last_data - 5.days)...last_data).each do |stream_datum|
        @data_x[index] << stream_datum.created_at.strftime("%Y-%m-%d %H:%M:%S")
        @data_y[index] << stream_datum.value
      end
    end

  end
  
end
