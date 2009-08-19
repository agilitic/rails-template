set :stages, %w(staging production)
set :default_stage, "production"
require 'capistrano/ext/multistage'