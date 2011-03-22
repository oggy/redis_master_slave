## Redis Master Slave

Redis master-slave client for Ruby.

Writes are directed to a master Redis server, while reads are distributed
round-robin across any number of slaves.

## Usage

    require 'redis_master_slave'

    client = RedisMasterSlave.new(YAML.load_file('redis.yml'))

    client.set('a', 1)         # writes to master
    client.get('a')            # reads from slaves, round-robin
    client.master.get('a')     # reads directly from master
    client.slaves[0].get('a')  # reads directly from first slave

### Configuration

The client can be configured in several ways.

#### Single configuration hash

Ideal for configuration via YAML file.

    client = RedisMasterSlave.new(YAML.load_file('redis.yml'))

Example YAML file:

    master:
      host: localhost
      port: 6379
    slaves:
      - host: localhost
        port: 6380
      - host: localhost
        port: 6381

#### URL strings

Specify the host and port for each Redis server as a URL string:

    master_url = "redis://localhost:6379"
    slave_urls = [
      "redis://localhost:6380",
      "redis://localhost:6381",
    ]
    client = RedisMasterSlave.new(master_urls, slave_urls)

#### Separate master and slave configurations

Specify master and slave configurations as separate hashes:

    master_config = {:host => 'localhost', :port => 6379}
    slave_configs = []
      {:host => 'localhost', :port => 6380},
      {:host => 'localhost', :port => 6381},
    ]
    client = RedisMasterSlave.new(master_config, slave_configs)

Each configuration hash is passed directly to `Redis.new`.

#### Redis client objects

You can also pass your own Redis client objects:

    master = Redis.new(:host => 'localhost', :port => 6379)
    slave1 = Redis.new(:host => 'localhost', :port => 6380)
    slave2 = Redis.new(:host => 'localhost', :port => 6381)
    client = RedisMasterSlave.new(master, [slave1, slave2])

## Contributing

 * [Bug reports.](https://github.com/oggy/redis_master_slave/issues)
 * [Source.](https://github.com/oggy/redis_master_slave)
 * Patches: Fork on Github, send pull request.
   * Please include tests where practical.
   * Leave the version alone, or bump it in a separate commit.

## Copyright

Copyright (c) George Ogata. See LICENSE for details.
