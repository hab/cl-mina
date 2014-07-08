namespace :log do
  desc "View tail of rails log"
  task :rails do
    queue "tail #{logs_path}/#{rails_env}.log -n 50"
  end

  desc "View tail of unicorn log"
  task :unicorn do
    queue "tail #{unicorn_log} -n 50"
  end

  desc "View tail of sidekiq log"
  task :sidekiq do
    queue "tail #{sidekiq} -n 50"
  end

  desc "View tail of nginx error log"
  task :nginx do
    queue "tail /var/log/nginx/error.log -n 50"
  end

  desc "View tail of nginx access log"
  task :nginx_access do
    queue "tail /var/log/nginx/access.log -n 50"
  end
end