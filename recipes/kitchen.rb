#
# cookbook::consul_fx
# recipe::kitchen
#
# author::fxinnovation
# description::Resource that provides install of consul
#

# Installing consul
consul_fx 'consul' do
  version       node['consul_fx']['consul']['version']
  checksum      node['consul_fx']['consul']['checksum']
  configuration node['consul_fx']['consul']['configuration']
  action        :install
end

# Starting consul
service 'consul' do
  action :start
end
