PROJECT_ROOT = File.dirname(File.dirname(__FILE__)) unless defined?(PROJECT_ROOT)

require 'rubygems'
require 'json'
require 'yaml'

# App
require File.join(PROJECT_ROOT, 'app.rb')
require File.join(PROJECT_ROOT, 'app_server.rb')

Dir[File.join(PROJECT_ROOT, 'lib', '*.rb')].each { |f| require f }

#require File.join(PROJECT_ROOT, 'app/initializers/rails_emulation.rb')
#require File.join(PROJECT_ROOT, 'app/initializers/bundler.rb')

#Dir[File.join(PROJECT_ROOT, 'app', 'preload_lib', '*.rb')].each { |f| require f }

# LOAD OLD APP
#load File.join(PROJECT_ROOT, 'lib/bootstrap.rb')

# Runs Initializers
#Dir[File.join(PROJECT_ROOT, 'app/initializers', '*.rb')].each { |f| require f }

# App
#Dir[File.join(PROJECT_ROOT, 'app', 'models', '*.rb')].each { |f| require f }
#Dir[File.join(PROJECT_ROOT, 'app', 'mailers', '*.rb')].each { |f| require f }
#Dir[File.join(PROJECT_ROOT, 'app', 'jobs', '*.rb')].each { |f| require f }
#Dir[File.join(PROJECT_ROOT, 'app', 'lib', '*.rb')].each { |f| require f }
#Dir[File.join(PROJECT_ROOT, 'app', 'controllers', '*.rb')].each{ |f| require f }

