# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'sandbox'
set :repo_url, 'git@github.com:Unix4ever/python-sandbox.git'  # Where to get APP from

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/srv/sandbox'

# Script for application starting
set :app_path, "#{release_path}/http_server.py"

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

set :env, "#{release_path}/env"

set :run_dir, "/var/run/"
set :log_dir, "/var/log/"
set :log_file, "#{fetch(:log_dir)}/#{fetch(:application)}.log"
set :pid_file, "#{fetch(:run_dir)}/#{fetch(:application)}.pid"

set :keep_releases, 5

set(:folders, [
  fetch(:run_dir),
  fetch(:log_dir),
  fetch(:deploy_to)
])

set(:config_files, %w(
  start.sh
))

set(:executable_config_files, %w(
  start.sh
))

# files which need to be symlinked to other parts of the
# filesystem. For example nginx virtualhosts, log rotation
# init scripts etc.
set(:symlinks, [
  {
    source: "start.sh", # Name of template without .erb
    link: "/etc/init.d/#{fetch(:application)}"
  }
])

namespace :deploy do

  # Creates all folders

  desc 'Prepare folders'
  task :prepare do
    on roles(:app), in: :parallel do

      # iterates over a list

      fetch(:folders).each do |folder|
      	# Folder creation, under sudo, because folder is created in /var, which is not accessible for regular user
        execute :sudo, :mkdir, "-p #{folder}"
        # chown -- Change ownership. Now we can do anything in this folder.
        # host.user is a user from which we start the service
        execute :sudo, :chown, host.user, "#{folder}"
      end
    end
  end

  # Installs all Python dependencies and makes virtualenv

  desc 'Install dependencies'
  task :install_dependencies do
    on roles(:app), in: :parallel do
      deps = ['python-dev', 'python-virtualenv']

      deps.each do |dependency|
        begin # try
          # dpkg -- system for deps installing
          # apt-get also a system to do this.
          # but dpkg does not resolve deps of deps.
          # dpkg install all package from dep files, which is already downloaded

          # this command in particular checks if dependency is installed
          execute "dpkg -l | grep #{dependency}" # grep filters output

          # if not found, it raises Exception
        rescue # catch
          info "Installing #{dependency}"
          execute :sudo, "apt-get install -q -y #{dependency}" # -y accepts automatically
        end
      end

      # release_path is defined by Capistrano by default
      execute "cd #{fetch(:release_path)} && virtualenv --python=python2.7 #{fetch(:env)} --no-site-packages --clear"
      execute "cd #{fetch(:release_path)} && #{fetch(:env)}/bin/pip install --download-cache #{shared_path}/cache -r requirements.txt"
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute "/etc/init.d/#{fetch(:application)} restart"
    end
  end

  before :deploy, 'deploy:prepare'
  # deploy is a step which installs the code on the system
  after :deploy, 'deploy:install_dependencies'
  # copies all configs with template processing
  after :publishing, :setup_config

  after :setup_config, :restart

  after :finishing, :cleanup

end
