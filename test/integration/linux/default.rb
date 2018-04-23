#
# Inspec test for adjoin_fx on debian platform family
#
# the Inspec refetence, with examples and extensive documentation, can be
# found at https://inspec.io/docker/reference/resources/
#
control "consul_fx - #{os.name} #{os.release}" do
  title 'Ensure consul is installed correctly'

  describe user('consul') do
    it           { should exist }
    its('uid')   { should < 1000 }
    its('group') { should eq 'consul' }
    its('home')  { should eq '/opt/consul' }
  end

  describe group('consul') do
    it { should exist }
  end

  describe command('/opt/consul/bin/consul --version') do
    its('exit_status') { should eq 0 }
  end

  %w(/opt/consul/bin/consul /opt/consul/conf.d/99_main.json).each do |configuration_file|
    describe file(configuration_file) do
      it           { should exist }
      its('group') { should eq 'consul' }
      its('owner') { should eq 'consul' }
      its('type')  { should eq :file }
    end
  end

  %w(/opt/consul /opt/consul/conf.d /opt/consul/bin /var/lib/consul).each do |consul_dir|
    describe directory(consul_dir) do
      it           { should exist }
      its('group') { should eq 'consul' }
      its('owner') { should eq 'consul' }
    end
  end

  describe service('consul') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end

  [8600, 8500, 8301, 8302, 8300].each do |consul_port|
    describe port(consul_port) do
      it { should be_listening }
      its('processes') { should include 'consul' }
    end
  end
end
