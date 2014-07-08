###########################################################################

#### Setup ####
# 1. Set "Common settings for all servers" in this file
# 2. Set environment-specific settings in config/deploy/staging.rb and config/deploy/production.rb
# 3. Verify defaults in config/deploy/defaults.rb

#### Usage ####
# mina [namespace]:[task] to=[server]

#### Usage Examples ####
# mina setup to=staging
# mina nginx:setup to=production
# mina log:rails to=production
###########################################################################

require 'mina/bundler'
require 'mina/rails'
require 'mina/git'

load 'config/deploy/defaults.rb'

require 'cl_mina/tasks/all'

# Load environments from config/deploy
Dir['config/deploy/*.rb'].each { |f| load f }

###########################################################################
# Common settings for all servers
###########################################################################

set :application,       "your_app"
set :application_name,  "Human Name for Your App"
set :domain_name,       "example.com"
set :keep_releases,     5
set :repository,        "user@git.example.com:/your-app.git"
set :default_server,    "staging"

# IRC options
set :send_irc_messages, true
set :irc_uri,           "irc://MinaBot:password@git.example.com:6697/#log"
set :irc_ssl,           true

# SSL Options
set :ssl_cert_path,     "/etc/nginx/ssl/your_app.crt"
set :ssl_cert_key_path, "/etc/nginx/ssl/your_app.key"

###########################################################################

set :server, ENV['to'] || default_server
invoke :"env:#{server}"

desc "Deploys the current version to the server."
task :deploy => :environment do
  deploy do
    invoke :'check:revision'
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'

    to :launch do
      invoke :'unicorn:restart'
    end

    if send_irc_messages
      invoke :'irc:announce_deploy'
    end
  end
end