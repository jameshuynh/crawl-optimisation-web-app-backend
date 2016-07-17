rails_env = ENV["RACK_ENV"] || ENV['RAILS_ENV']
app_path = "/home/app/www/seo/backend"
app_root = "#{app_path}/current"

Dir.chdir(Unicorn::HttpServer::START_CTX[:cwd] = app_root)
working_directory app_root

Unicorn::HttpServer::START_CTX[0] = "#{app_root}/bin/unicorn"

pid_file = "#{app_root}/tmp/pids/seo_backend.pid"
stderr_path  "#{app_path}/shared/log/seo_backend.log"
stdout_path  "#{app_path}/shared/log/seo_backend.log"
old_pid = pid_file + '.oldbin'

pid pid_file
listen "/tmp/seo_backend.sock"
worker_processes 1
preload_app true
timeout 3000

before_exec do |server|
  ENV["BUNDLE_GEMFILE"] = "#{app_root}/Gemfile"
end

before_fork do |server, worker|

  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
  end

  old_pid = "#{server.config[:pid]}.oldbin"
  if old_pid != server.pid
    begin
      sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
      Process.kill(sig, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end

  # Throttle the master from forking too quickly by sleeping.
  sleep 1
end

after_fork do |server, worker|
  # the following is *required* for Rails + "preload_app true",
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
  end

  # if preload_app is true, then you may also want to check and
  # restart any other shared sockets/descriptors such as Memcached,
  # and Redis. TokyoCabinet file handles are safe to reuse
  # between any number of forked children (assuming your kernel
  # correctly implements pread()/pwrite() system calls)

  begin
    uid, gid = Process.euid, Process.egid
    user, group = 'app', 'app'
    target_uid = Etc.getpwnam(user).uid
    target_gid = Etc.getgrnam(group).gid
    worker.tmp.chown(target_uid, target_gid)
    if uid != target_uid || gid != target_gid
      Process.initgroups(user, target_gid)
      Process::GID.change_privilege(target_gid)
      Process::UID.change_privilege(target_uid)
    end
  rescue => e
  end
end
