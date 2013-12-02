require 'spec_helper_system'
require 'securerandom'

describe 'graylog::install: create config' do
  before :all do
    pp = <<-EOS.unindent
      class { 'graylog::server':
        ensure => present,
        password_secret => '#{(0...50).map{ ('a'..'z').to_a[rand(26)] }.join}',
        root_password_sha2 => '#{Digest::SHA2.new.update('rootpw').to_s}',
    }
    EOS
    puppet_apply(pp) do |r|
      r.exit_code.should_not == 1
    end
  end

  it 'should create a config file' do
    shell('cat /etc/graylog2/graylog2.conf') do |r|
      r.stdout.should =~ /is_master = true/
    end
  end

  it 'should copy the graylog jar to /opt/graylog2' do
    shell('ls /opt/graylog2/graylog2-server.jar') do |r|
      r.exit_code.should == 0
    end
  end

  it 'should be able to print the version' do
    shell('java -jar /opt/graylog2/graylog2-server.jar --version') do |r|
      r.exit_code.should == 0
      r.stdout.should =~ /Graylog2 Server/
    end
  end
end
