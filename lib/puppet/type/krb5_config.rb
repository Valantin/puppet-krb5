# frozen_string_literal: true

Puppet::Type.newtype(:krb5_config) do
  @doc = 'Manage krb5.conf file'

  ensurable do
    desc 'Ensurable method handles modeling creation. It creates an ensure property'
    newvalue(:present) do
      provider.create
    end
    newvalue(:absent) do
      provider.destroy
    end
    def insync?(current)
      if @resource[:refreshonly]
        true
      else
        current == should
      end
    end
    defaultto :present
  end

  newparam(:name, namevar: true) do
    desc 'An arbitrary name used as the identity of the resource.'
  end

  newparam(:section) do
    desc 'The name of the section in the ini file in which the setting should be defined.'
    defaultto('')
  end

  newparam(:setting) do
    desc 'The name of the setting to be defined.'
    munge do |value|
      Puppet.warn('Settings should not have spaces in the value, we are going to strip the whitespace') if value.match?(%r{(^\s|\s$)})
      value.strip
    end
  end

  newparam(:path) do
    desc 'The conf file Puppet will ensure contains the specified setting.'
    validate do |value|
      raise(Puppet::Error, format(_("File paths must be fully qualified, not '%{value}'"), value: value)) unless Puppet::Util.absolute_path?(value)
    end
    defaultto('/etc/kerb5.conf')
  end

  newproperty(:value) do
    desc 'The value of the setting to be defined.'

    def insync?(current)
      if @resource[:refreshonly]
        true
      else
        current == should
      end
    end
  end

  def refresh
    return provider.destroy if self[:ensure] == :absent && self[:refreshonly]

    # update the value in the provider, which will save the value to the ini file
    provider.value = self[:value] if self[:refreshonly]
  end

  autorequire(:file) do
    Pathname.new(self[:path]).parent.to_s
  end
end
