require 'colorize'

# Tag deployments in git
require 'capistrano-deploytags'

# Prompt for deployment if migrations are present
require 'capistrano-detect-migrations'

# Colorize this mofo!
require 'capistrano_colors'

# The name of the application, used for several things
set :application, "wessels"

# Set up the stages. Default to staging so we don't accidentally
# deploy to production without meaning to.
set :stages, %w(production)
set :default_stage, "production"

# Note that we have to bring this in AFTER we define the stages
require 'capistrano/ext/multistage'

# We'll use git with a local copy to store the code we'll be deploying
set :scm, :git
set :scm_verbose, true
set :repository, "git@github.com:jshafton/hackathon-client.git"
set :branch, "master"

# Deploy via a file copy instead of going through SCM on the remote machine
set :deploy_via, :copy

# Using the copy_cache specifies that Capistrano makes a copy of your repo
# on the local machine (defaults to the /tmp folder) and then just does an
# update on it before copying to the remote.
#
# If you don't use this option, it will do a full checkout instead. Slower.
set :copy_cache, true

# Exclude these files from the deployment
set :copy_exclude, [".git"]

# Turn off sudo - this user should have the necessary permissions w/o it
set :use_sudo, false

# Deployment goes into the /opt/rails-apps and sets up a directory for the specific app
set :deploy_to, "/opt/rails-apps/#{application}"

# Deploy tasks - start and stop aren't really possible with Passenger
#              - restart updates the restart.txt, which Passenger monitors
namespace :deploy do

  desc "Restarting mod_rails with restart.txt"

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end

  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end

end

# Bring in Bundler to ensure the appropriate gems are installed during deployment
require "bundler/capistrano"

# Exclude OSX, development, and test environment gems
set :bundle_without, %w(development development_caching test)

# Pre-compile assets during the deployment process. For this to work, the server
# needs to have a JavaScript framework installed. Recommend adding the following
# to your Gemfile:
#
#   gem 'therubyracer', :require => nil
load 'deploy/assets'

# Clean up old releases after deployment
after "deploy", "deploy:cleanup"
after "deploy:migrations", "deploy:cleanup"

# No need to touch asset filese to update timestamps; this is handled by the
# asset pipeline in Rails 3 (we hope)
set :normalize_asset_timestamps, false
