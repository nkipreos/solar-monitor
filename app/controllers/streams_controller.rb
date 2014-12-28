class StreamsController < ApplicationController

  def show
    @remote_devices = []
    @current_user.accounts.each do |account|
      account.remote_devices.each do |remote_device|
        @remote_devices << remote_device
      end
    end
  end

  def create
    st = Stream.create({:name => params[:stream_name], :stream_type => params[:stream_type], :remote_device_id => params[:remote_device_id]})
    unless st.errors.nil?
      flash[:error] = "Error while creating stream"
    end
    redirect_to '/streams/show'
  end

end
