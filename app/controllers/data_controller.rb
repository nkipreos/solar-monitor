class DataController < ApplicationController

  def create
    begin
      raise "Value must be specified" if params[:value].blank?
      remote_device = RemoteDevice.find_by_unique_id(request.headers["REMOTE-DEVICE-ID"])
      stream = Stream.where(:remote_device_id => remote_device.id).find_by_unique_id(request.headers["STREAM-ID"])
      stream_data = StreamData.create({:value => params[:value], :stream_id => stream.id}) unless stream.blank?
      response = {
        :status => "ok", 
        :reponse => [
          :remote_device_name => remote_device.name, 
          :stream_name => stream.name,
          :saved_value => stream_data.value
          ]
        }
      render json: response.to_json
    rescue => e
      render_json_exception(e.to_s)
    end
  end

end