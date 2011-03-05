require 'redis'

module RedisMasterSlave
  autoload :Client, 'redis_master_slave/client'
  autoload :ReadOnly, 'redis_master_slave/read_only'
  autoload :ReadOnlyError, 'redis_master_slave/read_only'

  #
  # Create a new client. Same as Client.new.
  #
  def self.new(*args, &block)
    Client.new(*args, &block)
  end
end
