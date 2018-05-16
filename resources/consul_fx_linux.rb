#
# cookbook::consul_fx
# resource::consul_fx
#
# author::fxinnovation
# description::Resource that installs on configures consul on linux servers
#

# Declaring resource name
resource_name :consul_fx

# Declaring provider
provides :consul_fx, os: 'linux'

# Declaring properties
property :url,               String
property :checksum,          String
property :version,           String, default:  '0.7.5'
property :user,              String, default:  'consul'
property :group,             String, default:  'consul'
property :shell,             String, default:  '/sbin/nologin'
property :service_name,      String, default:  'consul'
property :install_directory, String, default:  '/opt/consul'
property :data_directory,    String, default:  '/var/lib/consul'
property :cache_dir,         String, default:  Chef::Config['file_cache_path']
property :configuration,     Hash,   required: true

# Default action
default_action :install

# Declaring install action
action :install do
  # Defining download url
  if new_resource.property_is_set?(:url)
    url = new_resource.url
  else
    url = "https://releases.hashicorp.com/consul/#{new_resource.version}/consul_#{new_resource.version}_linux"
    url << case node['kernel']['machine']
           when 'x86_64'
             '_amd64.zip'
           when ''
             '_386.zip'
           else
             Chef::Log.fatal('The system\'s architecture is not supported')
           end
  end

  # Declaring group
  declare_resource(:group, new_resource.group)

  # Declaring user
  declare_resource(:user, new_resource.user) do
    group   new_resource.group
    shell   new_resource.shell
    comment 'User for consul agent'
    home    new_resource.install_directory
    system  true
    action  :create
  end

  # Creating install_directory
  directory new_resource.install_directory do
    action :create
    mode   '0750'
    owner  new_resource.user
    group  new_resource.group
  end

  # Creating configuration directory
  directory "#{new_resource.install_directory}/conf.d" do
    action :create
    mode   '0750'
    owner  new_resource.user
    group  new_resource.group
  end

  # Creating binary directory
  directory "#{new_resource.install_directory}/bin" do
    action :create
    mode   '0750'
    owner  new_resource.user
    group  new_resource.group
  end

  # Creating data directory
  directory new_resource.data_directory do
    action :create
    mode   '0750'
    owner  new_resource.user
    group  new_resource.group
  end

  # Installing unzip
  unzip_fx 'consul' do
    source     url
    checksum   new_resource.checksum if new_resource.property_is_set?(:checksum)
    target_dir "#{new_resource.install_directory}/bin"
    creates    'consul'
    action     :extract
  end

  # Making sure consul permissions are set
  file "#{new_resource.install_directory}/bin/consul" do
    owner  new_resource.user
    group  new_resource.group
    mode   '0750'
    action :create
  end

  # Making sure consul is in path
  link '/usr/local/bin/consul' do
    to        "#{new_resource.install_directory}/bin/consul"
    link_type :symbolic
  end

  # Making sure configuration has data path
  new_configuration = new_resource.configuration.merge(data_dir: new_resource.data_directory)

  # Configuring consul
  consul_fx_configuration 'main' do
    configuration_directory "#{new_resource.install_directory}/conf.d"
    configuration           new_configuration
  end

  # Installing consul service
  consul_fx_service new_resource.service_name do
    install_dir new_resource.install_directory
    user        new_resource.user
    group       new_resource.group
    action      :create
  end
end
