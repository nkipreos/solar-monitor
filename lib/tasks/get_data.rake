namespace :stream_data do
  task :get_data, [:date] => :environment do |t, args|
    f = File.open('out.txt', 'w+')
    StreamData.where(:measured_at => args[:date].to_date.beginning_of_day..args[:date].to_date.end_of_day).each do |datum|
      f.write("#{datum.value}, #{datum.measured_at}\r\n")
    end
  end
end
