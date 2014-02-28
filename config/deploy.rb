# config valid only for Capistrano 3.1
lock '3.1.0'

set :application, 'hrlabs'
set :repo_url, 'git@github.com:IvanShamatov/hrlabs.ru.git'

# set :shared_children, shared_children + %w{tmp/uploads}


# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/home/deployer/hrlabs.ru'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :rvm_ruby_version, '2.0.0-p247'

# Default value for keep_releases is 5
# set :keep_releases, 5


namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      within release_path do
        execute :bundle, "exec thin restart -C config/thin.yml"
      end
    end
  end
  before :restart, 'rvm:hook'

  task :start do
    on roles(:app), in: :sequence, wait: 5 do
      within release_path do
        execute :bundle, "exec thin start -C config/thin.yml"
      end
    end
  end
  before :start, 'rvm:hook'

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
