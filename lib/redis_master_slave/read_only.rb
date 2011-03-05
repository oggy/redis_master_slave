module RedisMasterSlave
  #
  # Clients with no master defined are extended with this module.
  #
  # Attempts to access #writable_master will raise a ReadOnly::Error.
  #
  module ReadOnly
    def writable_master
      raise ReadOnlyError, "no master available"
    end
  end

  ReadOnlyError = Class.new(RuntimeError)
end
