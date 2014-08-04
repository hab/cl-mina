###########################################################################
#### Setup ####
# 1. Set common settings for all servers in this file
# 2. Set environment-specific settings in config/deploy/staging.rb and config/deploy/production.rb
# 3. Verify defaults in config/deploy/defaults.rb

#### Usage ####
# mina [namespace]:[task] to=[server]

#### Usage Examples ####
# mina setup to=staging
# mina nginx:setup to=production
# mina log:rails to=production
# mina deploy
###########################################################################

# Include built-in mina tasks
require 'mina/bundler'
require 'mina/rails'
require 'mina/git'

# Load default configuration from deploy/defaults
load 'config/deploy/defaults.rb'

# Load all tasks in cl-mina gem
require 'cl_mina/tasks/all'

# Load environments from config/deploy
Dir['config/deploy/*.rb'].each { |f| load f }

###########################################################################
# Common settings for all servers
###########################################################################

# application
# The...unix-safe name of the application.
# It will be used when generating directories, files, usernames, etc.
# Guidelines for naming:
# - No spaces. Things will break.
# - For the sake of standardization, go for all lowercase unless you have a
#   really good reason not to.
set :application,       "your_app"

# application_name
# The name of the application.
# This is used any time a script broadcasts messages, like upon deployment.
# Spaces are fine, even encouraged, here.
set :application_name,  "Human Name for Your App"

# domain_name
# The domain name where the application will live.
# Use the generic domain name that will apply across environments.
# You can customize it for specific environments in environment-specific configuration.
set :domain_name,       "example.com"

# keep_releases
# Number of releases to keep when deploying.
# If there are more releases than this on the server, the oldest will be deleted.
# TODO: actually implement this.
set :keep_releases,     5

# respository
# The repository where the application lives.
# Only supports git.
# When you deploy, the server will pull from this repository to create a new release.
# SSH agent forwarding is enabled by default, so the server will use the key
# you're using to ssh into the server to fetch the respository. If your key works
# when using the git server directly but not when you're deploying, it's probably
# an ssh-agent issue. Github has pretty good documentation about that.
set :repository,        "user@git.example.com:your-app.git"

# default_server
# The server to run a task on if one is not specified.
# If you don't specify a server with to=whatever, this is the server where the task(s)
# will run. Change to production at your own risk.
set :default_server,    "staging"

##### IRC options #####
# If you want to use IRC, set these.

# send_irc_messages
# Whether to send irc announcements.
# If you set this to false, you can ignore the other irc settings.
set :send_irc_messages, true

# irc_uri
# Format: irc://{nick}:{password}@{server name}:{port}/#{channel}
set :irc_uri,           "irc://MinaBot:password@git.example.com:6697/#log"

# irc_ssl
# Whether to use ssl when connecting to the irc server
set :irc_ssl,           true

##### End IRC options #####

##### SSL options ####
# If you're using https, you can use these options combined with the environment
# deploy configuration to set up nginx config.
set :ssl_cert_path,     "/etc/nginx/ssl/your_app.crt"
set :ssl_cert_key_path, "/etc/nginx/ssl/your_app.key"

###########################################################################

# Set server based on "to" environment variable.
# E.g., mina deploy to=production
set :server, ENV['to'] || default_server

# Load environment-specific deploy config from config/deploy/
invoke :"env:#{server}"

# This is what happens when you run mina deploy
desc "Deploys the current version to the server."
task :deploy => :environment do
  deploy do
    # Make sure local git branch is synced with remote
    invoke :'check:revision'

    # Clone git repository to create a new release
    invoke :'git:clone'

    # Link configuration you want shared across releases into new release
    invoke :'deploy:link_shared_paths'

    # Install gems for new release
    # Gems are shared across releases, so they won't need to be installed on every deploy.
    invoke :'bundle:install'

    # Migrate database. If there are no new migrations, does nothing.
    invoke :'rails:db_migrate'

    # Precompile assets. If there are no changed assets, does nothing.
    invoke :'rails:assets_precompile'

    to :launch do
      invoke :'unicorn:restart'
    end

    if send_irc_messages
      invoke :'irc:announce_deploy'
    end
  end
end