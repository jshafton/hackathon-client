# A sample Guardfile
# More info at https://github.com/guard/guard#readme

if RUBY_PLATFORM.downcase.include?("darwin")
  notification :growl
else
  notification :off
end

guard 'spork', :cucumber_env => { 'RAILS_ENV' => 'test' }, :rspec_env => { 'RAILS_ENV' => 'test' } do
  watch('config/application.rb')
  watch('config/environment.rb')
  watch(%r{^config/environments/.+\.rb$})
  watch(%r{^config/initializers/.+\.rb$})
  watch('Gemfile')
  watch('Gemfile.lock')
  watch('spec/spec_helper.rb') { :rspec }
  watch('test/test_helper.rb') { :test_unit }
  watch(%r{features/support/}) { :cucumber }
end

guard 'livereload' do
  watch(%r{app/.+\.(erb|haml|slim|rabl)})
  watch(%r{app/helpers/.+\.rb})
  watch(%r{(public/|app/assets).+\.(css|js|html)})
  watch(%r{app/assets/.+\.hbs})
  watch(%r{(app/assets/.+\.css)\.s[ac]ss}) { |m| m[1] }
  watch(%r{(app/assets/.+\.js)\.coffee}) { |m| m[1] }
  watch(%r{config/locales/.+\.yml})
end

guard 'coffeescript', :output => 'tmp/javascripts/compiled/app' do
  watch(/^app\/assets\/javascripts\/.+\.coffee/)
end

guard 'coffeescript', :output => 'tmp/javascripts/compiled/spec' do
  watch(/^spec\/javascripts\/(.*).coffee/)
end

guard 'jasmine', :server => :none, :jasmine_url => 'http://localhost:3000/jasmine' do
  watch(%r{spec/javascripts/spec\.(js\.coffee|js|coffee)$})         { "spec/javascripts" }
  watch(%r{tmp/javascripts/compiled/spec/.+_spec\.(js\.coffee|js|coffee)$})
  watch(%r{app/assets/javascripts/(.+?)\.(js\.coffee|js|coffee)$})  { |m| "tmp/javascripts/compiled/spec/#{m[1]}_spec.#{m[2]}" }
end
