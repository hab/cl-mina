task :setup do
  invoke :'postgresql:setup' if setup_postgresql
  invoke :'clouddb:setup' if setup_clouddb
  invoke :'nginx:setup'
  invoke :'unicorn:setup'
  invoke :'logrotate:setup'
  invoke :create_extra_paths
end

task :create_extra_paths do
  queue 'echo "-----> Create configs path"'
  queue echo_cmd "mkdir -p #{config_path}"

  queue 'echo "-----> Create shared paths"'
  shared_dirs = shared_paths.reject{|p| p.match(/\./)}.map { |file| "#{deploy_to}/#{shared_path}/#{file}" }.uniq
  cmds = shared_dirs.map do |dir|
    queue echo_cmd %{mkdir -p "#{dir}"}
  end

  queue 'echo "-----> Create PID and Sockets paths"'
  cmds = [pids_path, sockets_path].map do |path|
    queue echo_cmd %{mkdir -p #{path}}
  end
end

def template(from, to, *opts)
  templates_path ||= File.expand_path("../../templates", __FILE__)
  queue %{echo "-----> Creating file at #{to} using template #{from}"}
  if opts.include? :tee
    command = ''
    command << 'sudo ' if opts.include? :sudo
    command << %{tee #{to} <<'zzENDOFFILEzz' > /dev/null\n}
    command << %{#{erb("#{templates_path}/#{from}")}}
    command << %{\nzzENDOFFILEzz}
  else
    command = %{echo '#{erb("#{templates_path}/#{from}")}' > #{to}}
  end
  queue command
end