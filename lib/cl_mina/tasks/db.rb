namespace :db do
  desc "Run db:seed"
  task :seed do
    queue %{cd #{deploy_to}/#{current_path}}
    queue %{bundle exec rake RAILS_ENV=#{rails_env} db:seed}
    invoke :'irc:announce_seed'
  end

  desc "Run apartment:migrate"
  task :apartment_migrate do
    queue %{cd #{deploy_to}/#{current_path}}
    queue %{bundle exec rake RAILS_ENV=#{rails_env} apartment:migrate}
  end
end