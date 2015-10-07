class DataController < ApplicationController

  skip_before_filter :authenticate, :only => [:index, :devices]

  def create
    begin
      raise "Value must be specified" if params[:value].blank?
      remote_device = RemoteDevice.find_by_unique_id(request.headers["REMOTE-DEVICE-ID"])
      stream = Stream.where(:remote_device_id => remote_device.id).find_by_unique_id(request.headers["STREAM-ID"])
      filename = "tmp/cache/#{stream.id}"
      if File.exist?(filename)
        last_datum = File.read(filename)
      else
        File.open(filename, 'w') {|x| x.write("{\"measured_at\": \"#{params[:measured_at]}\", \"value\": \"#{params[:value]}\"}")}
        last_datum = File.read(filename)
      end
      last_datum = JSON.parse(last_datum)
      if ((Time.parse(last_datum['measured_at']).utc() - Time.parse(params[:measured_at]).utc()).abs < 60.seconds ) && ((params[:value].to_i - last_datum['value'].to_i).abs > 30)
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
      File.open(filename, 'w') {|x| x.write("{\"measured_at\": \"#{params[:measured_at]}\", \"value\": \"#{params[:value]}\"}")}
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
        text << "*" + stream.name + '*: '
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

  def devices
    base_url = (Rails.env == 'development') ? 'https://api.telegram.org/bot123319927:AAHjHrJaPT9rOBqLpusRvIoTxDUIDsvSRA8/' : ENV['BASE_URL']
    command = params['message']['text'].split(' ')[0]
    argument_1 = params['message']['text'].split(' ')[1]
    argument_2 = params['message']['text'].scan(/'([^<>]*)'/imu).flatten[0]
    case command
    when '/user'
      user = User.find_by_username(argument_1)
      unless user.blank?
        keyboard = []
        user.accounts.each do |account|
          account.remote_devices.each do |rd|
            keyboard << ["/device #{argument_1} '#{rd.name}'"]
          end
        end
        text = "Elija una dispositivo"
        json_data = {"chat_id" => params['message']['chat']['id'],"text" => text,"reply_markup" => {"keyboard" => keyboard,"one_time_keyboard" => true}}
        Curl.post(base_url + 'sendMessage', json_data.to_json) do |http|
          http.headers['Content-Type'] = 'application/json'
        end
      else
        text = 'User not found'
      end
    when '/device'
      user = User.find_by_username(argument_1)
      unless user.blank?
        if user.accounts.map {|x| x.remote_devices.map {|x| x.name}}.flatten.include?(argument_2)
          remote_device = RemoteDevice.find_by_name(argument_2)
          keyboard = []
          remote_device.streams.each do |stream|
            keyboard << ["/stream #{stream.name} #{stream.unique_id[-5..-1]}"]
          end
          text = "Elija una canal"
          json_data = {"chat_id" => params['message']['chat']['id'],"text" => text,"reply_markup" => {"keyboard" => keyboard,"one_time_keyboard" => true}}
          req = Curl.post(base_url + 'sendMessage', json_data.to_json) do |http|
            http.headers['Content-Type'] = 'application/json'
          end
        end
      end
    when '/stream'
      stream_id = params['message']['text'].split(' ')[-1]
      unless Stream.where('unique_id like ?', "%#{stream_id}%").blank?
        stream = Stream.where('unique_id like ?', "%#{stream_id}%").last
        last_datum = StreamData.where(stream.id).last
        text = "*#{stream.name}:*\n#{last_datum.value}\n#{last_datum.measured_at}"
        json_data = {"chat_id" => params['message']['chat']['id'],"text" => text, "parse_mode" => "Markdown"}
        req = Curl.post(base_url + 'sendMessage', json_data.to_json) do |http|
          http.headers['Content-Type'] = 'application/json'
        end
      end
    end
    render json: {'response' => 'ok'}
  end

end