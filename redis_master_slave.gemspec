$:.unshift File.expand_path('lib', File.dirname(__FILE__))
require 'redis_master_slave/version'

Gem::Specification.new do |s|
  s.name        = 'redis_master_slave'
  s.date        = Time.now.strftime('%Y-%m-%d')
  s.version     = RedisMasterSlave::VERSION.join('.')
  s.authors     = ["George Ogata"]
  s.email       = ["george.ogata@gmail.com"]
  s.homepage    = "http://github.com/oggy/redis_master_slave"
  s.summary     = "Redis master-slave client for Ruby."

  s.add_dependency 'redis'
  s.add_development_dependency 'ritual', '0.2.0'
  s.required_rubygems_version = ">= 1.3.6"
  s.files = Dir["lib/**/*"] + %w(LICENSE README.markdown Rakefile CHANGELOG)
  s.test_files = Dir["spec/**/*"]
  s.extra_rdoc_files = ["LICENSE", "README.markdown"]
  s.require_path = 'lib'
  s.specification_version = 3
end
