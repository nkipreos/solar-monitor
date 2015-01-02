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
      StreamData.where(:stream_id => stream.id).last(1000).each do |stream_datum|
        @data_x[index] << stream_datum.created_at.strftime("%Y-%m-%d %H:%M:%S")
        @data_y[index] << stream_datum.value
      end
    end

  end
  
end
