set :application, "PROJECT_NAME"

set :scm,                   :git
set :repository,            "ssh://agilitic.com/git/#{application}.git"
set :branch,                "master"
set :deploy_via,            :remote_cache

set :deploy_to, "/www/staging/#{application}"

role :app, "agilitic.com"
role :web, "agilitic.com"
role :db,  "agilitic.com", :primary => true

set :user,   "deploybot"
set :runner, "deploybot"

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