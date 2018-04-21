#
# cookbook::vault_fx
# resource::vault_fx
#
# author::fxinnovation
# description::Resource that installs on configures vault on linux servers
#

# Declaring resource name
resource_name :vault_fx

# Declaring provider
provides :vault_fx, os: 'linux'

# Declaring properties
property :url,               String
property :checksum,          String
property :version,           String, default:  '0.10.0'
property :user,              String, default:  'vault'
property :group,             String, default:  'vault'
property :service_name,      String, default:  'vault'
property :install_directory, String, default:  '/opt/vault'
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
    url = "https://releases.hashicorp.com/vault/#{new_resource.version}/vault_#{new_resource.version}_linux"
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
    shell   '/bin/bash'
    comment 'User for vault agent'
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

  # Installing unzip
  unzip_fx 'vault' do
    source     url
    checksum   new_resource.checksum if new_resource.property_is_set?(:checksum)
    target_dir "#{new_resource.install_directory}/bin"
    creates    'vault'
    action     :extract
  end

  # Making sure vault permissions are set
  file "#{new_resource.install_directory}/bin/vault" do
    owner  new_resource.user
    group  new_resource.group
    mode   '0750'
    action :create
  end

  # Making sure vault is in path
  link '/usr/local/bin/vault' do
    to        "#{new_resource.install_directory}/bin/vault"
    link_type :symbolic
  end

  # Configuring vault
  file "#{new_resource.install_directory}/conf.d/configuration.json" do
    content new_resource.configuration.to_json
    owner  new_resource.user
    group  new_resource.group
    mode   '0640'
    action :create
  end

  # Installing vault service
  vault_fx_service new_resource.service_name do
    install_dir new_resource.install_directory
    user        new_resource.user
    group       new_resource.group
    action      :create
  end
end
