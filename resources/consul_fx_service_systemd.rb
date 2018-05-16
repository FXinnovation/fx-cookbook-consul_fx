#
# cookbook::consul_fx
# resource::consul_fx_service
#
# author::fxinnovation
# description::Creates a systemd service unit for consul
#

# Defining resource name
resource_name :consul_fx_service

# Declaring provider
provides :consul_fx_service, os: 'linux' do |node|
  node['init_package'] == 'systemd'
end

# Defining properties
property :install_dir, String, required: true
property :user,        String, required: true
property :group,       String, required: true

# Defining default action
default_action :create

# Defining create action
action :create do
  # Consul systemd execStart command
  exec_start = "#{new_resource.install_dir}/bin/consul agent "
  exec_start << "-config-dir #{new_resource.install_dir}/conf.d"

  # systemd unit file for consul service
  systemd_unit "#{new_resource.name}.service" do
    content(
      Unit: {
        Description: 'Consul systemd service unit',
        After:       'network.online.target',
      },
      Service: {
        ExecStart:  exec_start,
        Restart:    'always',
        User:       new_resource.user,
        Group:      new_resource.group,
      },
      Install: {
        WantedBy: 'multi-user.target',
      }
    )
    action [:create, :enable]
  end
end
