source 'http://rubygems.org'

gem 'rails', '3.1.3'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

# Format templates with the awesome Slim template engine
gem 'slim'

# RABL API template builder for easier JSON output
gem 'rabl'

# Setting this to not-required so we don't have a runtime dependency on it.
# Need to discuss in more detail how we want to handle this.
gem 'therubyracer', :require => nil

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.1.5'
  gem 'coffee-rails', '~> 3.1.1'
  gem 'uglifier', '>= 1.0.3'
  gem 'handlebars_assets'
end

gem 'jquery-rails'

# color log output
gem 'colorize'

# SASS implementation of Twitter's Bootstrap
gem 'bootstrap-sass', '~> 2.0.4'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

# in the test/development section, like so...
group :test, :development, :development_caching do
  gem 'pry', '~> 0.9.9'
  gem 'pry-debugger'
  gem 'pry-stack_explorer'
  gem 'rails-dev-tweaks', '~> 0.6.1'
  gem "jasmine"
  gem "jasminerice"
  gem "guard-jasmine"
  gem "awesome_print"
  gem "rspec-rails", "~> 2.6"
  gem "spork"
  gem "guard-spork"
  gem "guard-rspec"
  gem 'guard-livereload'
  gem "guard-coffeescript"
  gem 'rb-fsevent', :require => nil
  gem 'ruby_gntp', :require => nil
  gem 'growl', :require => nil
end

gem 'pusher'
