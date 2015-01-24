namespace :logrotate do
  desc "Setup logrotate for all log files in log directory"
  task :setup do
    template "logrotate.erb", "/tmp/logrotate"
    queue echo_cmd "sudo mv /tmp/logrotate /etc/logrotate.d/#{application}_#{deploy_server}"
  end
  after "deploy:setup", "logrotate:setup"
end