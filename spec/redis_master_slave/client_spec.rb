require 'spec/spec_helper'

describe RedisMasterSlave do
  describe "#initialize" do
    it "should accept URI strings" do
      client = RedisMasterSlave::Client.new('redis://localhost:6479', 'redis://localhost:6480')
      mc, sc = client.master.client, client.slave.client
      [mc.host, mc.port].should == ['localhost', 6479]
      [sc.host, sc.port].should == ['localhost', 6480]
    end

    it "should accept Redis configuration hashes" do
      client = RedisMasterSlave::Client.new({:host => 'localhost', :port => 6479},
                                            {:host => 'localhost', :port => 6480})
      mc, sc = client.master.client, client.slave.client
      [mc.host, mc.port].should == ['localhost', 6479]
      [sc.host, sc.port].should == ['localhost', 6480]
    end

    it "should accept Redis client objects" do
      master = Redis.new(:host => 'localhost', :port => 6479)
      slave  = Redis.new(:host => 'localhost', :port => 6480)
      client = RedisMasterSlave::Client.new(master, slave)
      client.master.should equal(master)
      client.slave.should equal(slave)
    end
  end

  describe "read operations" do
    before do
      @client = RedisMasterSlave::Client.new(@master, @slave)
    end

    it "should hit the slave" do
      @slave.slaveof 'no', 'one'
      @slave.set 'a', 'y'
      @master.set 'a', 'x'
      @client.get('a').should == 'y'
    end
  end

  describe "other operations" do
    before do
      @client = RedisMasterSlave::Client.new(@master, @slave)
    end

    it "should hit the master" do
      @client.set 'a', 'z'
      @client.master.get('a').should == 'z'
      @client.slave.get('a').should be_nil
    end
  end
end
