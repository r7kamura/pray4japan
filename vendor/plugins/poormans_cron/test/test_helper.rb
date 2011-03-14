ENV['RAILS_ENV'] = 'test'
ENV['RAILS_ROOT'] ||= File.dirname(__FILE__) + '/../../../..'
require File.expand_path(File.join(ENV['RAILS_ROOT'], 'config/environment.rb'))

require 'test/unit'
require 'active_support/test_case'
require 'action_controller/test_case'
require 'action_controller/test_process'
require 'rr'
require 'shoulda'

ActiveRecord::Base.logger = Logger.new(File.join(File.dirname(__FILE__), "/../debug.log"))
ActiveRecord::Base.establish_connection({:adapter=>"sqlite3", :database=>"poormanscron_plugin.sqlite3.db"})
load(File.dirname(__FILE__) + "/schema.rb")

class Test::Unit::TestCase
  include RR::Adapters::TestUnit
end
