class RemoteDevicesController < ApplicationController

  def create
    rd = RemoteDevice.create({:name => params[:remote_device_name], :location_name => params[:location_name], :latitude => params[:latitude], :longitude => params[:longitude], :account_id => params[:account_id]})
    flash[:error] = ("Error while creating stream") unless rd.errors.messages.blank?
    redirect_to '/streams/show'
  end

end