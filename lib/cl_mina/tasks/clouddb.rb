require "highline/import"

namespace :clouddb do
  desc "Generate the database.yml configuration file"
  task :setup do
    get_clouddb_password
    template "clouddb.yml.erb", "#{config_path}/database.yml"
  end
end

def get_clouddb_password
  if !clouddb_password
    pw = ask "Database password: " do |p|
      p.echo = '*'
    end
    set :clouddb_password, pw
  end
end