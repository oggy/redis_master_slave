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
      slave0_port = ENV['REDIS_MASTER_SLAVE_SLAVE0_PORT'] || 6480
      slave1_port = ENV['REDIS_MASTER_SLAVE_SLAVE1_PORT'] || 6481
      @master = ::Redis.new(:host => 'localhost', :port => master_port)
      @slave0  = ::Redis.new(:host => 'localhost', :port => slave0_port)
      @slave1  = ::Redis.new(:host => 'localhost', :port => slave1_port)
      @master.flushdb
      @slave0.flushdb
      @slave1.flushdb
    end

    def quit_from_redises
      @master.quit
      @slave0.quit
      @slave1.quit
    end

    attr_reader :master, :slave0, :slave1
  end
end
