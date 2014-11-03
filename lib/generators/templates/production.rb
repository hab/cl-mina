namespace :env do
  task :production => [:environment] do
    # server_ip
    # Ip address of server to deploy staging app to
    set :server_ip,       '1.1.1.1'

    # domain
    # Domain of staging app.
    # Feel free to leave as server_ip.
    set :domain,          server_ip

    # deploy_server
    set :deploy_server,   'production'

    # rails_env
    # Rails environment to use when setting up and running the app.
    set :rails_env,       'production'

    # branch
    # git branch that is used to create new releases.
    set :branch,          'master'

    # rewrite_www
    # Whether to include logic in nginx to rewrite www.example.com to example.com.
    set :rewrite_www,     false

    # include_ssl
    # Whether to include ssl configuration in nginx config.
    set :include_ssl,     false

    # default_host
    # Whether the app should be set as the default host in nginx config.
    # Generally, you'll want true if it's the only app running on the server.
    # If there are multiple apps running on the server, make sure only one of them
    # is set as the default.
    set :default_host,    true

    # unicorn_workers
    # Number of unicorn workers to run for this server. Keep in mind that workers
    # will briefly overlap when transitioning to new release during unicorn:restart.
    set :unicorn_workers, 2

    # sidekiq_concurrency
    # Number of threads created by one sidekiq process
    set :sidekiq_concurrency, 5

    # Set all other configuration using config/deploy/defaults.rb
    invoke :defaults
  end
end