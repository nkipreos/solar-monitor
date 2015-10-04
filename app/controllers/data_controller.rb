class DataController < ApplicationController

  skip_before_filter :authenticate, :only => [:index]

  def create
    begin
      raise "Value must be specified" if params[:value].blank?
      remote_device = RemoteDevice.find_by_unique_id(request.headers["REMOTE-DEVICE-ID"])
      stream = Stream.where(:remote_device_id => remote_device.id).find_by_unique_id(request.headers["STREAM-ID"])
      unless StreamData.where(:stream_id => stream.id).blank?
        last_datum = StreamData.where(:stream_id => stream.id).order('measured_at asc').last
        if ((last_datum.measured_at - Time.parse(params[:measured_at]).utc()).abs < 60.seconds ) && ((params[:value].to_i - last_datum.value.to_i).abs > 30)
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

  def index
    base_url = ENV['BASE_URL']
    rd = RemoteDevice.find_by_name(params['message']['text'])
    unless rd.blank?
      text = "*Datos*\n\n"
      Stream.where(:remote_device_id => rd.id).each do |stream|
        text << "*" + stream.stream_type + '*: '
        text << '_' + StreamData.where(:stream_id => stream.id).last['value'].to_s + " - " + StreamData.where(:stream_id => stream.id).last['measured_at'].to_s + "_\n" unless StreamData.where(:stream_id => stream.id).last.nil?
      end
      response = {
        location: rd.location_name,
        latitude: rd.latitude,
        logitude: rd.longitude
      }
      Curl.post(base_url + 'sendLocation', {
        :chat_id => params['message']['chat']['id'],
        :latitude => rd.latitude,
        :longitude => rd.longitude
        })
      Curl.post(base_url + 'sendMessage', {
        :chat_id => params['message']['chat']['id'],
        :text => text,
        :parse_mode => 'Markdown'
        })
      render json: {'response' => response}
    else
      render json: {'response' => 'error'}
    end
  end

end