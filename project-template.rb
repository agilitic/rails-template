################################################################################
# agilitic SRCL base Rails template
# http://en.agilitic.com
################################################################################

BASE_GH_URL = 'http://github.com/agilitic/rails-template/raw/master/files'

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

options[:use_globalization] = yes?('Use globalization?') # install globalize/translates_routes
options[:use_wysiwyg] = yes?('Use wysiwyg?')
options[:bootstrap_smtp] = yes?('Bootstrap smtp?')
options[:bootstrap_contact_form] = yes?('Bootstrap contact form?')
options[:bootstrap_google_map] = yes?('Bootstrap google maps?')
options[:use_capistrano] = yes?('Use Capistrano?')

# Rails plugins & gems =========================================================

plugin 'acts_as_list',       :git => 'git://github.com/rails/acts_as_list.git'
plugin 'responds_to_parent', :git => 'git://github.com/markcatley/responds_to_parent.git' if options[:use_responds_to_parent]
plugin 'hoptoad_notifier',   :git => 'git://github.com/thoughtbot/hoptoad_notifier.git' if options[:use_hoptoad]
plugin 'misc_validators',    :git => 'git://github.com/aurels/misc_validators.git'

gem 'authlogic'
gem 'will_paginate'
gem 'paperclip'

if options[:use_globalization]
  gem 'globalize2'
  plugin 'translate_routes', :git => 'git://github.com/raul/translate_routes.git'
  copy_remote_file 'lib/tasks/translator.rake'
  copy_remote_file 'lib/active_record/globalize_extensions.rb'
end

if options[:use_geokit]
  gem 'geokit'
  plugin 'geokit-rails', :git => 'git://github.com/andre/geokit-rails.git'
  copy_remote_file 'config/initializers/geokit.rb'
end

rake "gems:install"

# Config =======================================================================

copy_remote_files(["config/config.yml", "config/initializers/load_config.rb"])

# Rake tasks ===================================================================

copy_remote_files(["lib/tasks/bootstrap.rake", "lib/tasks/seed.rake", "lib/tasks/cron.rake", "lib/tasks/uml.rake"])

# Authentication system & admin layout =========================================

generate :session_migration
generate :model, 'user', 'username:string', 'email:string', 'crypted_password:string', 'password_salt:string', 'persistence_token:string', 'admin:boolean'
generate :session, 'user_session'

copy_remote_files([
  'app/views/layouts/admin.html.erb',
  'app/views/admin/shared/_tabs.html.erb',
  'public/stylesheets/admin.css',
  'public/images/admin/alert-overlay.png',
  'public/images/admin/check.gif',
  'public/images/admin/x.gif',
  'public/images/admin/x2.gif'
])

copy_remote_files([
  'app/views/layouts/application.html.erb',
  'app/models/user.rb',
  'app/controllers/application_controller.rb',
  'app/controllers/base_controller.rb',
  'app/controllers/users_controller.rb',
  'app/controllers/user_sessions_controller.rb',
  'app/controllers/admin/base_controller.rb',
  'app/controllers/admin/users_controller.rb',
  'app/views/users/_form.html.erb',
  'app/views/users/new.html.erb',
  'app/views/users/index.html.erb',
  'app/views/users/edit.html.erb',
  'app/views/admin/users/index.html.erb',
  'app/views/admin/users/_form.html.erb',
  'app/views/admin/users/new.html.erb',
  'app/views/admin/users/edit.html.erb',
  'app/views/admin/users/show.html.erb',
  'app/views/admin/users/_user.html.erb',
  'app/helpers/layout_helper.rb',
  'app/helpers/error_messages_helper.rb',
  'app/views/user_sessions/new.html.erb'
])

# Routes =======================================================================

copy_remote_file 'config/routes.rb'

# Javascripts ==================================================================

copy_remote_files([
  'public/javascripts/jquery-1.3.2.min.js',
  'public/javascripts/jquery-ui-1.7.2.custom.min.js',
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

# Misc =========================================================================

copy_remote_file 'config/database.yml'
copy_remote_file '.gems'

run "rm public/index.html"
run "rm public/javascripts/prototype.js"
run "rm public/javascripts/effects.js"
run "rm public/javascripts/dragdrop.js"
run "rm public/javascripts/controls.js"

rake "db:migrate"
rake "app:bootstrap"

# Initializers =================================================================

copy_remote_file 'config/initializers/action_view_hacks.rb'
copy_remote_file 'public/images/exclamation.png'

# Capistrano ===================================================================

if options[:use_capistrano]
  capify!
  copy_remote_files([
    'config/deploy.rb',
    'config/deploy/production.rb',
    'config/deploy/staging.rb'
  ])
end

run "cp config/environments/production.rb config/environments/staging.rb"

# Git setup ====================================================================

copy_remote_file '.gitignore'

git :init
git :add => "."
git :commit => "-a -m 'Initial commit'"