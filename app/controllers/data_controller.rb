class DataController < ApplicationController

  def create
    begin
      raise "Value must be specified" if params[:value].blank?
      remote_device = RemoteDevice.find_by_unique_id(request.headers["REMOTE-DEVICE-ID"])
      stream = Stream.where(:remote_device_id => remote_device.id).find_by_unique_id(request.headers["STREAM-ID"])
      last_datum = StreamData.where(:stream_id => stream.id).order('measured_at asc').last
      if ((last_datum.measured_at - Time.parse(params[:measured_at]).utc()).abs < 60.seconds ) && ((params[:value].to_i - last_datum.value.to_i).abs > 60)
        response = {
          :status => "ok"
        }
      else
        stream_data = StreamData.create({:value => params[:value], :stream_id => stream.id, :measured_at => params[:measured_at]}) unless stream.blank?
        response = {
          :status => "ok",
          :reponse => {
            :remote_device_name => remote_device.name, 
            :stream_name => stream.name,
            :saved_value => stream_data.value
            }
          }
      end
      render json: response.to_json
    rescue => e
      render_json_exception(e.to_s)
    end
  end

end