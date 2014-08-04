# What is mina?

Mina is a gem that allows you to easily write rake tasks to automate deployment tasks. Mina works by generating bash scripts that it then runs on a remote server. This gem includes tasks to configure and deploy to servers with nginx

# How to use

1. Add to Gemfile: `gem "cl-mina"`
2. Generate deploy configuration: `rails g cl-mina:install`
3. ???
4. Profit

In addition to the documentation here, `config/deploy.rb`, `config/deploy/production.rb`, and `config/deploy/staging.rb` are reasonably well-documented.

# Install

## Run generator

To create the necessary files to run the cl-mina tasks, run `rails generate cl-mina:install`. The install generator creates several files:
1. `config/deploy.rb` contains application-specific configuration for all environments as well as the basic deploy script.
2. `config/deploy/defaults.rb` contains defaults for configuration variables. Most of the time you won't need to modify this. This task is called by the specific environment tasks, and it will only set variables that have not been set for the environment.
3. `config/deploy/staging.rb`, `config/deploy/production.rb` contain configuration variables that are likely to be different for staging and production environments.
4. `config/environments/staging.rb` is a base environment configuration for a staging environment since Rails does not include one by default. Generally you will want to keep yours if you already have one.

## Customize configuration

For most applications, you'll want to edit three files. All the documentation you need should be in the files themselves.
1. `config/deploy.rb`
2. `config/deploy/production.rb`
3. `config/deploy/staging.rb`

# Tasks

To list all available tasks with descriptions, `mina tasks`.

To run a task, `mina namespace:task to={server}`. So for example, to deploy to production, you would execute `mina deploy to=production`. The default server is set in `config/deploy.rb`. It's a good idea to have the default set to staging to force yourself to be intentional in deploying to production. But that's up to you.

All of the tasks are in `lib/cl-mina/tasks`, so if you want to see what exactly a task is doing, look there.

Tasks are listed here by namespace. E.g., to set up a postgresql db and configuration, you'd execute `mina postgresql:setup` (or `mina postgresql:setup to=production` for production server).

## Variables

Tasks use variables set in the files in the `config/deploy/` directory. `config/deploy/defaults.rb` includes default variables for all servers/environments, and `config/deploy/production.rb` or `config/deploy/staging.rb` include values specific to the server/environment. If you want to change a variable, you should almost always do so in one of the files in the `config/deploy/` directory.

## Task descriptions by namespace

### db

`db:seed`  
**Run rake db:seed.**

### log

`log:rails`, `log:unicorn`, `log:sidekiq`, `log:nginx`, `log:nginx_access`  
**Display tail of log.** Gets log locations from variables. Number of lines shown determined by `log_tail` variable (default 50).

### logrotate

`logrotate:setup`  
**Sets up logrotate.** I bet you'd never have guessed that.

### nginx

`nginx:setup`  
**Creates nginx configuration and init script.** Overwrites any existing configuration and restarts nginx.

`nginx:remove`  
**Removes nginx configuration.** Removes config from `/etc/nginx/sites-enabled`, restarts nginx.

`nginx:start`, `nginx:stop`, `nginx:restart`  
**Start, stop, or restart nginx.**

### postgresql

`postgresql:setup`  
**Creates user and database along with matching database.yml file**. Asks for password, uses it for database user and database.yml template. If user or database already exists, the existing database/user is unchanged. Among other things, this means that if you run this after a user has been created, make sure you enter the same password, or the password in your database.yml file will not match the password of your db user. This is a bug, and it'll be fixed...eventually.

`postgresql:create_user`  
**Prompts for password, creates postgresql user with that password**. Generally, you should just run the :setup command above rather than running this directly. The username is determined by `postgresql_user` and by default is the the application name.

`postgresql:create_database`  
**Creates a database for the application.** As with :create_user, you should usually just use the :setup command instead of using this directly. The database name is determined by `postgresql_user` and is by default the application name along with the server name, e.g. "your_app_production".

### unicorn  

`unicorn:setup`  
**Create unicorn config and init script.**

`unicorn:start`, `unicorn:stop`, `unicorn:restart`  
**Start, stop, restart unicorn.**