set :deploy_to, "/www/production/#{application}"

# Target servers
role :app, "agilitic.com"
role :web, "agilitic.com"
role :db,  "agilitic.com", :primary => true

set :user,   "deploybot"
set :runner, "deploybot"