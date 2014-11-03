namespace :sidekiq do
  desc "Start sidekiq"
  task :start do
    queue %{cd #{deploy_to}/#{current_path}}

    queue %{echo "-----> Start sidekiq"}
    queue echo_cmd "bundle exec sidekiq -d -c #{sidekiq_concurrency} -e #{rails_env} -L #{sidekiq_log} -P #{sidekiq_pid}"
  end

  desc "Quiet sidekiq"
  task :quiet do
    queue %{cd #{deploy_to}/#{current_path}}
    queue echo_cmd "bundle exec sidekiqctl quiet #{sidekiq_pid}"
  end

  desc "Stop sidekiq"
  task :stop do
    queue %{cd #{deploy_to}/#{current_path}}
    queue echo_cmd "bundle exec sidekiqctl stop #{sidekiq_pid} 60"
  end

  desc "Restart sidekiq"
  task :restart do
    queue %{cd #{deploy_to}/#{current_path}}
    invoke :'sidekiq:stop'
    invoke :'sidekiq:start'
  end
end