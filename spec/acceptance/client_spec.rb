# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'krb5::client' do
  case fact('os.family')
  when 'RedHat'
    package_name = 'krb5-libs'
  when 'Debian'
    package_name = 'krb5-user'
  end

  context 'on host' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-PUPPET
        class { 'krb5::client': }
        PUPPET
      end
    end

    describe package(package_name) do
      it { is_expected.to be_installed }
    end

    describe file('/etc/krb5.conf') do
      it { is_expected.to exist }
    end
  end
end
