################################################################################
# agilitic SRCL base Rails template
# http://en.agilitic.com
################################################################################

BASE_GH_URL = 'http://github.com/aurels/agilitic-templates/raw/master/files'

def copy_remote_file(path)
  open("#{BASE_GH_URL}/#{path}").read
end

# Options ======================================================================

options = {}
options[:use_hoptoad] = yes?('Use hoptoad_notifier?')
options[:use_responds_to_parent] = yes?('Use responds_to_parent plugin?')

# Rails plugins ================================================================

plugin 'authlogic',          :git => 'git://github.com/binarylogic/authlogic.git'
plugin 'will_paginate',      :git => 'git://github.com/mislav/will_paginate.git'
plugin 'paperclip',          :git => 'git://github.com/thoughtbot/paperclip.git'
plugin 'acts_as_list',       :git => 'git://github.com/rails/acts_as_list.git'
plugin 'responds_to_parent', :git => 'git://github.com/markcatley/responds_to_parent.git' if options[:use_hoptoad]
plugin 'hoptoad_notifier',   :git => 'git://github.com/thoughtbot/hoptoad_notifier.git' if options[:use_responds_to_parent]
plugin 'misc_validators',    :git => 'git://github.com/aurels/misc_validators.git'

# Javascripts ==================================================================

# jquery
# jquery.ui
# facebox
# jquery.tablednd
# jquery.infinitecarousel
# lwrte

# Empty rake tasks =============================================================

rakefile "bootstrap.rake", <<CODE
  namespace :app do
    task :bootstrap do
    end
  end
CODE

rakefile "seed.rake", <<CODE
  namespace :app do
    task :seed do
    end
  end
CODE

# Authentication system ========================================================

generate :session_migration
generate :model, 'user', 'username:string', 'email:string', 'crypted_password:string', 'password_salt:string', 'persistance_token:string', 'admin:boolean'
generate :session, 'user_session'

[ 'app/views/layouts/application.html.erb',
  'app/models/user.rb',
  'app/controllers/application.rb',
  'app/controllers/base_controller.rb',
  'app/controllers/users_controller.rb',
  'app/controllers/user_sessions_controller.rb',
  'app/controllers/admin/base_controller.rb',
  'app/controllers/admin/users_controller.rb',
  'app/views/users/_form.html.erb',
  'app/views/users/new.html.erb',
  'app/views/users/edit.html.erb',
  'app/views/admin/users/index.html.erb',
  'app/views/admin/users/_form.html.erb',
  'app/views/admin/users/new.html.erb',
  'app/views/admin/users/edit.html.erb',
  'app/views/admin/users/show.html.erb',
  'app/helpers/layout_helper.rb',
  'app/helpers/error_messages_helper.rb' ].each do |path|
  file path, copy_remote_file(path)
end

route <<CODE
  map.resources :users
CODE

route <<CODE
  map.signup 'signup',
    :controller => 'users',
    :action => 'new'
CODE

route <<CODE
  map.resources :user_sessions
CODE

route <<CODE
  map.login 'login',
    :controller => 'user_sessions',
    :action => 'new'
CODE

route <<CODE
  map.logout 'logout',
    :controller => 'user_sessions',
    :action => 'destroy'
CODE

route <<CODE
  map.namespace :admin do |admin|
    admin.resources :users
    admin.root :controller => 'users'
  end
CODE

# Admin layout =================================================================

[ 'app/views/layouts/admin.html.erb',
  'app/views/shared/_tabs.html.erb',
  'public/stylesheets/admin.css',
  'public/images/admin/alert-overlay.png',
  'public/images/admin/check.gif',
  'public/images/admin/x.gif',
  'public/images/admin/x2.gif' ].each do |path|
  file path, copy_remote_file(path)
end

# Misc =========================================================================

run "cp config/database.yml config/database.yml.sample"
run "rm public/index.html"
rake "db:migrate"

# Initializers =================================================================

# if options[:use_hoptoad]
#   initializer 'hoptoad.rb', <<CODE
#     HoptoadNotifier.configure do |config|
#       config.api_key = 'HOPTOAD-KEY'
#     end
#   CODE
# end

# Capistrano ===================================================================

capify!

# file 'Capfile', CODE
#   load 'deploy' if respond_to?(:namespace) # cap2 differentiator
#   Dir['vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }
#   load 'config/deploy'
# CODE
# 
# file 'config/deploy.rb', <<CODE
#   set :application, "#{PROJECT_NAME}"
#   set :repository,  "ssh://agilitic.com/git/#{PROJECT_NAME}.git"
# 
#   set :scm,                   :git
#   set :branch,                "master"
#   set :deploy_via,            :remote_cache
# 
#   set :deploy_to, "/www/#{PROJECT_NAME}"
# 
#   role :app, "agilitic.com"
#   role :web, "agilitic.com"
#   role :db,  "agilitic.com", :primary => true
# 
#   set :user,   "deploybot"
#   set :runner, "deploybot"
# 
#   namespace :deploy do
#     desc "Restarting mod_rails with restart.txt"
#     task :restart, :roles => :app, :except => { :no_release => true } do
#       run "touch #{current_path}/tmp/restart.txt"
#     end
# 
#     [:start, :stop].each do |t|
#       desc "#{t} task is a no-op with mod_rails"
#       task t, :roles => :app do ; end
#     end
#   end
# CODE

# Git setup ====================================================================

file '.gitignore', <<CONTENT
  coverage/*
  log/*.log
  log/*.pid
  db/*.db
  db/*.sqlite3
  db/schema.rb
  tmp/**/*
  .DS_Store
  doc/api
  doc/app
  config/database.yml
  public/javascripts/all.js
  public/stylesheets/all.js
  coverage/*
  .dotest/*
  Thumbs.db
CONTENT

git :init
git :add => "."
git :commit => "-a -m 'Initial commit'"