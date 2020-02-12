app_name = "lvfp"
number_of_app_instances = 2
# Set the working application directory. This should be your rails app root dir, not the public dir
app_root = File.expand_path(File.dirname(__FILE__) + '/..')
working_directory app_root

# Number of processes
worker_processes number_of_app_instances
# Time-out
timeout 30

# Path for the Unicorn socket
listen "/tmp/unicorn.#{app_name}.sock"

# Set path for logging
stderr_path "#{app_root}/log/unicorn.log"
stdout_path "#{app_root}/log/unicorn.log"

# Set proccess id path
pid "#{app_root}/tmp/pids/unicorn.pid"
