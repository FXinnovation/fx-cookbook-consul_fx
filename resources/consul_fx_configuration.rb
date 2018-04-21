#
# cookbook::consul_fx
# resource::consul_fx_configuration
#
# author::fxinnovation
# description::This resource allows you to create consul configurations
#

# Defining resource name
resource_name :consul_fx_configuration

# Declare provider
provides :consul_fx_configuration

# Defining roperties
property :configuration,           Hash,    required: true
property :configuration_directory, String,  required: true
property :priority,                Integer, default:  99
property :user,                    String,  default:  'consul'
property :group,                   String,  default:  'consul'

# Defining default action
default_action :create

action :create do
  # Generating file
  file "#{new_resource.configuration_directory}/#{new_resource.priority}_#{new_resource.name}.json" do
    content  new_resource.configuration.to_json
    mode     '0640'              unless node['platform_family'] == 'windows'
    user     new_resource.user   unless node['platform_family'] == 'windows'
    group    new_resource.group  unless node['platform_family'] == 'windows'
  end
end
