set :stages, %w(staging production)
set :default_stage, "production"

set :application, "PROJECT_NAME"

# Git repository
set :scm,                   :git
set :repository,            "ssh://agilitic.com/git/#{application}.git"
set :branch,                "master"
set :deploy_via,            :remote_cache

# Passenger reciepes
namespace :deploy do
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
end

require 'capistrano/ext/multistage'