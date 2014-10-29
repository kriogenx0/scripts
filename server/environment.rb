PROJECT_ROOT = File.dirname(File.dirname(__FILE__)) unless defined?(PROJECT_ROOT)

require File.join(PROJECT_ROOT, 'app.rb')
App.start
require File.join(PROJECT_ROOT, 'bootstrap.rb')
