require 'erb'
require 'tempfile'

module Support
  module Redis
    def self.included(base)
      base.before { connect_to_redises }
      base.before { quit_from_redises }
    end

    def connect_to_redises
      master_port = ENV['REDIS_MASTER_SLAVE_MASTER_PORT'] || 6479
      slave_port = ENV['REDIS_MASTER_SLAVE_SLAVE_PORT'] || 6480
      @master = ::Redis.new(:host => 'localhost', :port => master_port)
      @slave  = ::Redis.new(:host => 'localhost', :port => slave_port)
      @master.slaveof 'no', 'one'
      @slave.slaveof 'localhost', master_port
      @master.flushdb
      @slave.flushdb
    end

    def quit_from_redises
      @master.quit
      @slave.quit
    end
  end
end
