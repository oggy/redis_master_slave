require 'redis'

module RedisMasterSlave
  autoload :Client, 'redis_master_slave/client'

  #
  # Create a new client. Same as Client.new.
  #
  def self.new(*args, &block)
    Client.new(*args, &block)
  end
end
