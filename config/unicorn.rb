rails_root = File.expand_path('../..', __FILE__)


working_directory rails_root

# This loads the application in the master process before forking
# worker processes
# Read more about it here:
# http://unicorn.bogomips.org/Unicorn/Configurator.html
preload_app true

timeout 120

# This is where we specify the socket.
# We will point the upstream Nginx module to this socket later on

worker_processes 2
listen 40500, :tcp_nopush => true

pid rails_root + "/tmp/pids/unicorn.pid"
listen rails_root + "/tmp/unicorn.solar-monitor.sock"

# Set the path of the log files inside the log folder of the testapp
stderr_path rails_root + "/log/unicorn.stderr.log"
stdout_path rails_root + "/log/unicorn.stdout.log"

before_fork do |server, worker|
# This option works in together with preload_app true setting
# What is does is prevent the master process from holding
# the database connection
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
# Here we are establishing the connection after forking worker
# processes
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end
