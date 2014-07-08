namespace :env do
  task :production => [:environment] do
    set :server_ip,       '1.1.1.1'
    set :domain,          server_ip
    set :deploy_server,   'production'
    set :rails_env,       'production'
    set :branch,          'master'
    set :rewrite_www,     false
    set :include_ssl,     false
    set :default_host,    true
    set :unicorn_workers, 2

    invoke :defaults
  end
end