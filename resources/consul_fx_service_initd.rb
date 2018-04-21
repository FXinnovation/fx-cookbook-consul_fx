#
# cookbook::consul_fx
# resource::consul_fx_service
#
# author::fxinnovation
# description::This resource provides a init.d service file for consul
#

# Defining resource name
resource_name :consul_fx_service

# Declaring provider
provides :consul_fx_service, os: 'linux' do |node|
  node['init_package'] == 'init'
end

# Defining properties
property :install_dir, String, required: true
property :user,        String, required: true
property :group,       String, required: true

# Defining default action
default_action :create

action :create do
  # Defining template variables
  daemon         = "#{new_resource.install_dir}/bin/consul"
  user           = new_resource.user
  pid_file       = '/var/run/consul.pid'
  environment    = {
    'GOMAXPROCS' => [node['cpu']['total'], 2].max.to_s,
    'PATH' => "/usr/local/bin:/usr/bin:/bin:#{new_resource.install_dir}/bin",
  }
  directory      = new_resource.install_dir
  daemon_options = "agent -config-dir #{new_resource.install_dir}/conf.d"
  stop_signal    = 'TERM'
  reload_signal  = 'HUP'

  template "/etc/init.d/#{new_resource.name}" do
    source   'sysvinit.service.erb'
    owner    'root'
    group    'root'
    mode     '0555'
    cookbook 'consul_fx'
    variables(
      daemon:         daemon,
      user:           new_resource.group,
      pid_file:       pid_file,
      environment:    environment,
      directory:      directory,
      daemon_options: daemon_options,
      stop_signal:    stop_signal,
      reload_signal:  reload_signal
    )
  end

  service 'consul' do
    action :enable
  end
end
