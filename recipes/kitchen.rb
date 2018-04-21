#
# cookbook::vault_fx
# recipe::kitchen
#
# author::fxinnovation
# description::Test recipe for vault_fx
#

# Installing vault
vault_fx 'vault' do
  checksum       node['vault_fx']['vault']['checksum']
  version        node['vault_fx']['vault']['version']
  configuration  node['vault_fx']['vault']['configuration']
end

service 'vault' do
  action :start
end
