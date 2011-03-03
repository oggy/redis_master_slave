module RedisMasterSlave
  VERSION = [0, 0, 0]

  class << VERSION
    include Comparable

    def to_s
      join('.')
    end
  end
end
