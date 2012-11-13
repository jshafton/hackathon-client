# Configure the servers for this environment
#
# Note that we set the web server to the :db role with primary as true because
# we want migrations to run on that box. We don't want the code deployed to
# the database server since it's not really being run there.
server 'checkov.arsalon', :app, :web, :cache, :db, :primary => true
set :port, 22123

# The user that will be used to perform the deployment
# Make sure the machine running Capistrano has a valid SSH key for this user
set :user, "rails"

# Set the environment that Rails will use for configuration
set :rails_env, "production"
