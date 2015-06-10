# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'qna'
set :repo_url, 'git@github.com:tonymadbrain/qna.git'
set :rails_env, :production

set :deploy_to, '/home/deployer/qna'
set :deploy_user, 'deployer'

set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/private_pub.yml', '.env', 'config/private_pub_thin.yml')
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads')

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # for passenger
      # execute :touch, release_path.join('tmp/restart.txt')
      # for unicorn
      invoke 'unicorn:restart'
    end
  end

  after :publishing, :restart

  # after :restart, :clear_cache do
  #   on roles(:web), in: :groups, limit: 3, wait: 10 do
  #     # Here we can do anything such as:
  #     # within release_path do
  #     #   execute :rake, 'cache:clear'
  #     # end
  #   end
  # end
end

namespace :sphinx do

  desc 'Restart sphinx'
  task :restart do
    on roles(:app) do
      invoke 'thinking_sphinx:index'
      invoke 'thinking_sphinx:restart'
    end
  end
end

# private pub tasks
set :private_pub_pid, -> { "#{current_path}/tmp/pids/thin.pid" }

namespace :private_pub do
  desc "Start private_pub server"
  task :start do
    on roles(:app) do
      within release_path do
        with rails_env: fetch(:stage) do
          execute :bundle, "exec thin -C config/private_pub_thin.yml -d -P #{fetch(:private_pub_pid)} start"
        end
      end
    end
  end

  desc "Stop private_pub server"
  task :stop do
    on roles(:app) do
      within release_path do
        execute "if [ -f #{fetch(:private_pub_pid)} ] && [ -e /proc/$(cat #{fetch(:private_pub_pid)}) ]; then kill -9 `cat #{fetch(:private_pub_pid)}`; fi"
      end
    end
  end

  desc "Restart private_pub server"
  task :restart do
    on roles(:app) do
      invoke 'private_pub:stop'
      invoke 'private_pub:start'
    end
  end
end

after 'deploy:restart', 'private_pub:restart'
after 'deploy:restart', 'sphinx:restart'
