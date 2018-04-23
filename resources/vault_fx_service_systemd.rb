#
# cookbook::vault_fx
# resource::vault_fx_service
#
# author::fxinnovation
# description::Creates a systemd service unit for vault
#

# Defining resource name
resource_name :vault_fx_service

# Declaring provider
provides :vault_fx_service, os: 'linux' do |node|
  node['init_package'] == 'systemd'
end

# Defining properties
property :install_dir, String, required: true
property :user,        String, required: true
property :group,       String, required: true
property :log_level,   String, default:  'info'

# Defining default action
default_action :create

# Defining create action
action :create do
  # Consul systemd execStart command
  exec_start = "#{new_resource.install_dir}/bin/vault server "
  exec_start << "-config #{new_resource.install_dir}/conf.d -log-level=#{new_resource.log_level}"

  # systemd unit file for vault service
  systemd_unit "#{new_resource.name}.service" do
    content(
      Unit: {
        Description: 'Vault systemd service unit',
        Requires:    'network-online.target',
        After:       'network-online.target',
      },
      Service: {
        ExecStart:    exec_start,
        Restart:      'always',
        User:         new_resource.user,
        Group:        new_resource.group,
        LimitMEMLOCK: 'infinity',
      },
      Install: {
        WantedBy: 'multi-user.target',
      }
    )
    action [:create, :enable]
  end
end
