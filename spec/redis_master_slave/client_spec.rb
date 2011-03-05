require 'spec/spec_helper'

describe RedisMasterSlave do
  describe "#initialize" do
    it "should accept a single configuration hash" do
      client = RedisMasterSlave::Client.new('redis://localhost:6479', ['redis://localhost:6480'])
      mc, scs = client.master.client, client.slaves.map{|s| s.client}
      [mc.host, mc.port].should == ['localhost', 6479]
      scs.map{|sc| [sc.host, sc.port]}.should == [['localhost', 6480]]
    end

    it "should accept URI strings" do
      client = RedisMasterSlave::Client.new('redis://localhost:6479', ['redis://localhost:6480'])
      mc, scs = client.master.client, client.slaves.map{|s| s.client}
      [mc.host, mc.port].should == ['localhost', 6479]
      scs.map{|sc| [sc.host, sc.port]}.should == [['localhost', 6480]]
    end

    it "should accept Redis configuration hashes" do
      client = RedisMasterSlave::Client.new({:host => 'localhost', :port => 6479},
                                            [{:host => 'localhost', :port => 6480}])
      mc, scs = client.master.client, client.slaves.map{|s| s.client}
      [mc.host, mc.port].should == ['localhost', 6479]
      scs.map{|sc| [sc.host, sc.port]}.should == [['localhost', 6480]]
    end

    it "should accept Redis client objects" do
      master = Redis.new(:host => 'localhost', :port => 6479)
      slave  = Redis.new(:host => 'localhost', :port => 6480)
      client = RedisMasterSlave::Client.new(master, [slave])
      client.master.should equal(master)
      client.slaves.size.should == 1
      client.slaves.first.should equal(slave)
    end

    it "should accept multiple slaves" do
      master = Redis.new(:host => 'localhost', :port => 6479)
      slave0 = Redis.new(:host => 'localhost', :port => 6480)
      slave1 = Redis.new(:host => 'localhost', :port => 6481)
      client = RedisMasterSlave::Client.new(master, [slave0, slave1])
      client.master.should equal(master)
      client.slaves.size.should == 2
      client.slaves[0].should equal(slave0)
      client.slaves[1].should equal(slave1)
    end

    it "should set index to 0" do
      client = RedisMasterSlave::Client.new('redis://localhost:6479', ['redis://localhost:6480'])
      client.index.should == 0
    end

    it "should not have a master connection if no master configuration is given" do
      client = RedisMasterSlave::Client.new(nil, ['redis://localhost:6480'])
      client.master.should be_nil
    end
  end

  describe "read operations" do
    it "should go to each slave, round-robin" do
      client = RedisMasterSlave::Client.new(master, [slave0, slave1])
      master.set 'a', 'am'
      slave0.set 'a', 'a0'
      slave1.set 'a', 'a1'
      client.get('a').should == 'a0'
      client.get('a').should == 'a1'
      client.get('a').should == 'a0'
    end

    it "should work for read-only clients" do
      client = RedisMasterSlave::Client.new(nil, [slave0])
      slave0.set 'a', '1'
      client.get('a').should == '1'
    end
  end

  describe "other operations" do
    it "should hit the master" do
      client = RedisMasterSlave::Client.new(master, [slave0, slave1])
      client.set 'a', 'z'
      client.master.get('a').should == 'z'
      client.slaves.map{|s| s.get('a')}.should == [nil, nil]
    end

    it "should raise a ReadOnlyError for read-only clients" do
      client = RedisMasterSlave::Client.new(nil, [slave0])
      lambda do
        client.set 'a', '1'
      end.should raise_error(RedisMasterSlave::ReadOnlyError)
    end
  end
end
