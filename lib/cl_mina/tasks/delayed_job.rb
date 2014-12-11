namespace :delayed_job do
  desc "Start delayed_job"
  task :start do
    queue %{cd #{deploy_to}/#{current_path}}

    queue %{echo "-----> Start delayed_job"}
    queue echo_cmd "RAILS_ENV=#{rails_env} bin/delayed_job start"
  end

  desc "Stop delayed_job"
  task :stop do
    queue %{cd #{deploy_to}/#{current_path}}
    queue echo_cmd "RAILS_ENV=#{rails_env} bin/delayed_job stop "
  end

  desc "Restart delayed_job"
  task :restart do
    queue %{cd #{deploy_to}/#{current_path}}
    invoke :'delayed_job:stop'
    invoke :'delayed_job:start'
  end
end