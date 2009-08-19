set :deploy_to, "/www/staging/#{application}"

# Target servers
role :app, "staging.agilitic.com"
role :web, "staging.agilitic.com"
role :db,  "staging.agilitic.com", :primary => true

set :user,   "deploybot"
set :runner, "deploybot"