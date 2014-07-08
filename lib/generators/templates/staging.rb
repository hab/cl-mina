namespace :env do
  task :staging => [:environment] do
    set :server_ip,       '1.1.1.1'
    set :domain,          server_ip
    set :deploy_server,   'staging'
    set :rails_env,       'staging'
    set :branch,          'staging'
    set :rewrite_www,     false
    set :include_ssl,     false
    set :default_host,    true
    set :unicorn_workers, 1

    invoke :defaults
  end
end