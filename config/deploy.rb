set :default_environment, {
  'PATH' => "/usr/local/rvm/gems/ruby-2.0.0-p195/bin:/usr/local/rvm/bin:/usr/local/rvm/gems/ruby-2.0.0-p195/bin:$PATH",
  'RUBY_VERSION' => 'ruby 2.0.0',
  'GEM_HOME'     => '/usr/local/rvm/gems/ruby-2.0.0-p195',
  'GEM_PATH'     => '/usr/local/rvm/gems/ruby-2.0.0-p195',
  'BUNDLE_PATH'  => '/usr/local/rvm/gems/ruby-2.0.0-p195'  # If you are using bundler.
}
set :rvm_type, :system
require "rvm/capistrano"
require 'bundler/capistrano'

default_run_options[:pty] = true  # Must be set for the password prompt from git to work
set :application, "rabel"

default_run_options[:pty] = true  # Must be set for the password prompt from git to work
set :repository, "git@github.com:irubi/rabel.git"  # Your clone URL
set :branch, "master"
set :scm, "git"
set :user, "root"  # The server's user for deploys
set :deploy_to, "/var/www/rabel"
set :deploy_via, :remote_cache
# default_environment['PATH']='$PATH:$HOME/bin:/usr/local/git/bin:/usr/local/ruby/bin'
set :use_sudo, false

ssh_options[:forward_agent] = true

set :git_shallow_clone, 1
set :git_enable_submodules, 1

role :web, "115.28.32.246"                          # Your HTTP server, Apache/etc
role :app, "115.28.32.246"                          # This may be the same as your `Web` server
role :db,  "115.28.32.246", :primary => true # This is where Rails migrations will run
ssh_options[:port] = 22

# tasks
namespace :deploy do
  task :start, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end

  desc "Compile assets"
  task :assets do
    run "cd #{current_path}; RAILS_ENV=production rake assets:precompile"
  end

  task :stop, :roles => :app do
    # Do nothing.
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
    run "mkdir -p #{current_path}/tmp/cache"
    run "cd #{current_path}; chmod -R 0777 log/"
    run "cd #{current_path}; chmod -R 0777 tmp/"
    run "cd #{current_path}; chmod -R 0777 public/"
    #run "cd #{shared_path}; chown -R nobody system/"
  end

  desc "Symlink shared resources on each release"
  task :symlink_shared, :roles => :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/config/application.yml #{release_path}/config/application.yml"
  end
end

namespace :db do
  desc "migrate db"
  task :migrate, :roles => :app do
    run "cd #{release_path} && RAILS_ENV=production rake db:migrate"
  end
end

# namespace :delayed_job do
#   desc "restart delayed_job"
#   task :start, :roles => :app do
#     run "cd #{current_path} && RAILS_ENV=production ruby script/delayed_job start"
#   end

#   desc "stop previous delayed_job"
#   task :stop, :roles => :app do
#     run "cd #{previous_release} && RAILS_ENV=production ruby script/delayed_job stop"
#   end
# end

# before 'deploy:symlink_shared', 'delayed_job:stop'
# after 'deploy:symlink_shared', 'delayed_job:start'

after 'deploy:update_code', 'deploy:symlink_shared'
after 'deploy:symlink_shared', 'db:migrate'
after "deploy:symlink_shared", "deploy:assets"