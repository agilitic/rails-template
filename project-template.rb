################################################################################
# agilitic SRCL base Rails template
# http://en.agilitic.com
################################################################################

# Rails plugins ================================================================

plugin 'authlogic',          :git => 'git://github.com/binarylogic/authlogic.git'
plugin 'will_paginate',      :git => 'git://github.com/mislav/will_paginate.git'
plugin 'paperclip',          :git => 'git://github.com/thoughtbot/paperclip.git'
plugin 'acts_as_list',       :git => 'git://github.com/rails/acts_as_list.git'
plugin 'responds_to_parent', :git => 'git://github.com/markcatley/responds_to_parent.git'
plugin 'hoptoad_notifier',   :git => 'git://github.com/thoughtbot/hoptoad_notifier.git'

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
generate :model, 'user', 'username:string', 'crypted_password:string', 'password_salt:string', 'persistance_token:string', 'admin:boolean'
generate :session, 'user_session'

file 'app/models/user.rb', <<RUBY
  class User < ActiveRecord::Base
    acts_as_authentic

    validates_confirmation_of :password
  end
RUBY

file 'app/admin/users_controller.rb', <<RUBY
  class Admin::UsersController < ApplicationController
    def index
      @users = User.all
    end
    
    def show
      
    end
    
    def new
      
    end
    
    def create
      
    end
    
    def edit
      
    end
    
    def update
      
    end
    
    def destroy
      
    end
    
    protected
    
    def get_users
      
    end
    
    def get_user
      
    end
  end
RUBY

#  route ''

# Misc =========================================================================

run "cp config/database.yml config/database.yml.sample"
run "rm public/index.html"
rake "db:migrate"

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


# initializer 'hoptoad.rb',
# %q{HoptoadNotifier.configure do |config|
# config.api_key = 'HOPTOAD-KEY'
# end
# }

# capify!



# file 'Capfile',
# %q{load 'deploy' if respond_to?(:namespace) # cap2 differentiator
# Dir['vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }
# load 'config/deploy'
# }
#  
# file 'config/database.yml',
# %q{<% PASSWORD_FILE = File.join(RAILS_ROOT, '..', '..', 'shared', 'config', 'dbpassword') %>
#  
# development:
# adapter: mysql
# database: <%= PROJECT_NAME %>_development
# username: root
# password:
# host: localhost
# encoding: utf8
# test:
# adapter: mysql
# database: <%= PROJECT_NAME %>_test
# username: root
# password:
# host: localhost
# encoding: utf8
# staging:
# adapter: mysql
# database: <%= PROJECT_NAME %>_staging
# username: <%= PROJECT_NAME %>
# password: <%= File.read(PASSWORD_FILE).chomp if File.readable? PASSWORD_FILE %>
# host: localhost
# encoding: utf8
# socket: /var/lib/mysql/mysql.sock
# production:
# adapter: mysql
# database: <%= PROJECT_NAME %>_production
# username: <%= PROJECT_NAME %>
# password: <%= File.read(PASSWORD_FILE).chomp if File.readable? PASSWORD_FILE %>
# host: localhost
# encoding: utf8
# socket: /var/lib/mysql/mysql.sock
# }
#  
# file 'config/deploy.rb',
# %q{set :stages, %w(staging production)
# set :default_stage, 'staging'
# require 'capistrano/ext/multistage'
#  
# before "deploy:setup", "db:password"
#  
# namespace :deploy do
# desc "Default deploy - updated to run migrations"
# task :default do
# set :migrate_target, :latest
# update_code
# migrate
# symlink
# restart
# end
# desc "Start the mongrels"
# task :start do
# send(run_method, "cd #{deploy_to}/#{current_dir} && #{mongrel_rails} cluster::start --config #{mongrel_cluster_config}")
# end
# desc "Stop the mongrels"
# task :stop do
# send(run_method, "cd #{deploy_to}/#{current_dir} && #{mongrel_rails} cluster::stop --config #{mongrel_cluster_config}")
# end
# desc "Restart the mongrels"
# task :restart do
# send(run_method, "cd #{deploy_to}/#{current_dir} && #{mongrel_rails} cluster::restart --config #{mongrel_cluster_config}")
# end
# desc "Run this after every successful deployment"
# task :after_default do
# cleanup
# end
# end
#  
# namespace :db do
# desc "Create database password in shared path"
# task :password do
# set :db_password, Proc.new { Capistrano::CLI.password_prompt("Remote database password: ") }
# run "mkdir -p #{shared_path}/config"
# put db_password, "#{shared_path}/config/dbpassword"
# end
# end
# }
#  
# file 'config/deploy/staging.rb',
# %q{# For migrations
# set :rails_env, 'staging'
#  
# # Who are we?
# set :application, 'CHANGEME'
# set :repository, "git@github.com:thoughtbot/#{application}.git"
# set :scm, "git"
# set :deploy_via, :remote_cache
# set :branch, "staging"
#  
# # Where to deploy to?
# role :web, "staging.example.com"
# role :app, "staging.example.com"
# role :db, "staging.example.com", :primary => true
#  
# # Deploy details
# set :user, "#{application}"
# set :deploy_to, "/home/#{user}/apps/#{application}"
# set :use_sudo, false
# set :checkout, 'export'
#  
# # We need to know how to use mongrel
# set :mongrel_rails, '/usr/local/bin/mongrel_rails'
# set :mongrel_cluster_config, "#{deploy_to}/#{current_dir}/config/mongrel_cluster_staging.yml"
# }
#  
# file 'config/deploy/production.rb',
# %q{# For migrations
# set :rails_env, 'production'
#  
# # Who are we?
# set :application, 'CHANGEME'
# set :repository, "git@github.com:thoughtbot/#{application}.git"
# set :scm, "git"
# set :deploy_via, :remote_cache
# set :branch, "production"
#  
# # Where to deploy to?
# role :web, "production.example.com"
# role :app, "production.example.com"
# role :db, "production.example.com", :primary => true
#  
# # Deploy details
# set :user, "#{application}"
# set :deploy_to, "/home/#{user}/apps/#{application}"
# set :use_sudo, false
# set :checkout, 'export'
#  
# # We need to know how to use mongrel
# set :mongrel_rails, '/usr/local/bin/mongrel_rails'
# set :mongrel_cluster_config, "#{deploy_to}/#{current_dir}/config/mongrel_cluster_production.yml"
# }