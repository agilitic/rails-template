################################################################################
# agilitic SRCL base Rails template
# http://en.agilitic.com
################################################################################

BASE_GH_URL = 'http://github.com/aurels/agilitic-templates/raw/master/files'

def copy_remote_file(path)
  open("#{BASE_GH_URL}/#{path}").read
end

def copy_remote_files(array)
  array.each { |i| copy_remote_file(i) }
end

# Options ======================================================================

options = {}
options[:use_hoptoad] = yes?('Use hoptoad_notifier plugin?')
options[:use_geokit] = yes?('Use GeoKit gem?')
options[:use_responds_to_parent] = yes?('Use responds_to_parent plugin?')

# Rails plugins & gems =========================================================

plugin 'authlogic',          :git => 'git://github.com/binarylogic/authlogic.git'
plugin 'will_paginate',      :git => 'git://github.com/mislav/will_paginate.git'
plugin 'paperclip',          :git => 'git://github.com/thoughtbot/paperclip.git'
plugin 'acts_as_list',       :git => 'git://github.com/rails/acts_as_list.git'
plugin 'responds_to_parent', :git => 'git://github.com/markcatley/responds_to_parent.git' if options[:use_hoptoad]
plugin 'hoptoad_notifier',   :git => 'git://github.com/thoughtbot/hoptoad_notifier.git' if options[:use_responds_to_parent]
plugin 'misc_validators',    :git => 'git://github.com/aurels/misc_validators.git'
gem 'geokit' if options[:use_geokit]

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

# Authentication system & admin layout =========================================

generate :session_migration
generate :model, 'user', 'username:string', 'email:string', 'crypted_password:string', 'password_salt:string', 'persistance_token:string', 'admin:boolean'
generate :session, 'user_session'

copy_remote_files([
  'app/views/layouts/admin.html.erb',
  'app/views/shared/_tabs.html.erb',
  'public/stylesheets/admin.css',
  'public/images/admin/alert-overlay.png',
  'public/images/admin/check.gif',
  'public/images/admin/x.gif',
  'public/images/admin/x2.gif'
])

copy_remote_files([
  'app/views/layouts/application.html.erb',
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
  'app/helpers/error_messages_helper.rb'
])

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

# Javascripts ==================================================================

copy_remote_files([
  'public/javascripts/jquery-1.3.2.min.js',
  'public/javascripts/jquery.ui-1.7.2.custom.min.js',
  'public/javascripts/jquery.tablednd.js'
])

copy_remote_files([
  'public/facebox/b.png',
  'public/facebox/bl.png',
  'public/facebox/br.png',
  'public/facebox/closelabel.gif',
  'public/facebox/facebox.css',
  'public/facebox/facebox.js',
  'public/facebox/loading.gif',
  'public/facebox/README.txt',
  'public/facebox/tl.png',
  'public/facebox/tr.png'
])

copy_remote_files([
  'public/infinite_carousel/images/arrow_blank.png',
  'public/infinite_carousel/images/arrow.png',
  'public/infinite_carousel/infinite_carousel.css',
  'public/infinite_carousel/infinite_carousel.js',
])

# lwrte

# Misc =========================================================================

run "cp config/database.yml config/database.yml.sample"
run "rm public/index.html"
run "rm public/javascripts/prototype.js"
run "rm public/javascripts/effects.js"
run "rm public/javascripts/dragdrop.js"
run "rm public/javascripts/controls.js"
rake "db:migrate"
rake "gems:install"

# Initializers =================================================================

# if options[:use_hoptoad]
#   initializer 'hoptoad.rb', <<CODE
#     HoptoadNotifier.configure do |config|
#       config.api_key = 'HOPTOAD-KEY'
#     end
#   CODE
# end

# if options[:use_geokit]
#   initializer 'geokit.rb' <<CODE
#     GMAPS_API_KEY = YAML.
#       load_file(
#         File.join(RAILS_ROOT, 'config', 'gmaps.yml')
#       )[RAILS_ENV]
# 
#     if defined? Geokit
# 
#       # These defaults are used in Geokit::Mappable.distance_to and in acts_as_mappable
#       Geokit::default_units = :miles
#       Geokit::default_formula = :sphere
# 
#       # This is the timeout value in seconds to be used for calls to the geocoder web
#       # services.  For no timeout at all, comment out the setting.  The timeout unit
#       # is in seconds. 
#       Geokit::Geocoders::timeout = 3
# 
#       # These settings are used if web service calls must be routed through a proxy.
#       # These setting can be nil if not needed, otherwise, addr and port must be 
#       # filled in at a minimum.  If the proxy requires authentication, the username
#       # and password can be provided as well.
#       Geokit::Geocoders::proxy_addr = nil
#       Geokit::Geocoders::proxy_port = nil
#       Geokit::Geocoders::proxy_user = nil
#       Geokit::Geocoders::proxy_pass = nil
# 
#       # This is your yahoo application key for the Yahoo Geocoder.
#       # See http://developer.yahoo.com/faq/index.html#appid
#       # and http://developer.yahoo.com/maps/rest/V1/geocode.html
#       Geokit::Geocoders::yahoo = 'REPLACE_WITH_YOUR_YAHOO_KEY'
# 
#       # This is your Google Maps geocoder key. 
#       # See http://www.google.com/apis/maps/signup.html
#       # and http://www.google.com/apis/maps/documentation/#Geocoding_Examples
#       Geokit::Geocoders::google = GMAPS_API_KEY
# 
#       # This is your username and password for geocoder.us.
#       # To use the free service, the value can be set to nil or false.  For 
#       # usage tied to an account, the value should be set to username:password.
#       # See http://geocoder.us
#       # and http://geocoder.us/user/signup
#       Geokit::Geocoders::geocoder_us = false 
# 
#       # This is your authorization key for geocoder.ca.
#       # To use the free service, the value can be set to nil or false.  For 
#       # usage tied to an account, set the value to the key obtained from
#       # Geocoder.ca.
#       # See http://geocoder.ca
#       # and http://geocoder.ca/?register=1
#       Geokit::Geocoders::geocoder_ca = false
# 
#       # Uncomment to use a username with the Geonames geocoder
#       #Geokit::Geocoders::geonames="REPLACE_WITH_YOUR_GEONAMES_USERNAME"
# 
#       # This is the order in which the geocoders are called in a failover scenario
#       # If you only want to use a single geocoder, put a single symbol in the array.
#       # Valid symbols are :google, :yahoo, :us, and :ca.
#       # Be aware that there are Terms of Use restrictions on how you can use the 
#       # various geocoders.  Make sure you read up on relevant Terms of Use for each
#       # geocoder you are going to use.
#       Geokit::Geocoders::provider_order = [:google,:us]
# 
#       # The IP provider order. Valid symbols are :ip,:geo_plugin.
#       # As before, make sure you read up on relevant Terms of Use for each
#       # Geokit::Geocoders::ip_provider_order = [:geo_plugin,:ip]
#     end
#   CODE
#   
#   file 'config/gmaps.yml', <<YML
#     development: DEVELOPMENT_KEY
#     staging: STAGING_KEY
#     production: PRODUCTION_KEY
#   YML
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