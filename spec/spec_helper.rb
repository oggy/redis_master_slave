ROOT = File.expand_path('..', File.dirname(__FILE__))

$:.unshift "#{ROOT}/lib"
require 'redis_master_slave'
require 'rspec'

require 'spec/support/redis'

RSpec.configure do |c|
  c.include Support::Redis
end
