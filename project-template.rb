################################################################################
# agilitic SRCL base Rails template
# http://en.agilitic.com
################################################################################

BASE_GH_URL = 'http://github.com/aurels/agilitic-templates/raw/master/files'

def copy_remote_file(path)
  file(path, open("#{BASE_GH_URL}/#{path}").read)
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
plugin 'responds_to_parent', :git => 'git://github.com/markcatley/responds_to_parent.git' if options[:use_responds_to_parent]
plugin 'hoptoad_notifier',   :git => 'git://github.com/thoughtbot/hoptoad_notifier.git' if options[:use_hoptoad]
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
generate :model, 'user', 'username:string', 'email:string', 'crypted_password:string', 'password_salt:string', 'persistence_token:string', 'admin:boolean'
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
  'app/views/admin/users/_user.html.erb',
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

if options[:use_hoptoad]
  copy_remote_file 'config/initializers/hoptoad.rb'
end

if options[:use_geokit]
  copy_remote_files([
    'config/gmaps.yml',
    'config/initializers/geokit.rb'
  ])
end

# Capistrano ===================================================================

capify!

copy_remote_file 'config/deploy.rb'

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