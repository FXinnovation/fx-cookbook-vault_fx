#
# Inspec test for vault_fx cookbook on linux OS
#
# the Inspec refetence, with examples and extensive documentation, can be
# found at https://inspec.io/docker/reference/resources/
#
control "vault_fx - #{os.name} #{os.release}" do
  title 'Ensure vault is installed'

  describe user('vault') do
    it           { should exist }
    its('uid')   { should < 1000 }
    its('group') { should eq 'vault' }
    its('home')  { should eq '/opt/vault' }
  end

  describe group('vault') do
    it { should exist }
  end

  describe command('/opt/vault/bin/vault --version') do
    its('exit_status') { should eq 0 }
  end

  %w(/opt/vault/bin/vault /opt/vault/conf.d/configuration.json).each do |configuration_file|
    describe file(configuration_file) do
      it           { should exist }
      its('group') { should eq 'vault' }
      its('owner') { should eq 'vault' }
      its('type')  { should eq :file }
    end
  end

  %w(/opt/vault /opt/vault/conf.d /opt/vault/bin).each do |vault_dir|
    describe directory(vault_dir) do
      it           { should exist }
      its('group') { should eq 'vault' }
      its('owner') { should eq 'vault' }
    end
  end

  describe service('vault') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end

  [8200].each do |vault_port|
    describe port(vault_port) do
      it { should be_listening }
      its('processes') { should include 'vault' }
    end
  end
end
