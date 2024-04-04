# frozen_string_literal: true

require 'spec_helper'

describe 'krb5::client' do
  on_supported_os.each do |os, os_facts|
    case os_facts[:os]['family']
    when 'RedHat'
      package_name = 'krb5-libs'
    when 'Debian'
      package_name = 'krb5-user'
    end

    context "on #{os}" do
      let(:facts) { os_facts }
      let(:params) do
        {
          libdefaults: {
            default_realm: 'ATHENA.MIT.EDU',
            default_tkt_enctypes: 'des3-hmac-sha1 des-cbc-crc',
            default_tgs_enctypes: 'des3-hmac-sha1 des-cbc-crc',
            dns_lookup_kdc: true,
            dns_lookup_realm: false
          },
          realms: {
            'ATHENA.MIT.EDU': {
              kdc: ['kerberos.mit.edu', 'kerberos-1.mit.edu', 'kerberos-2.mit.edu:750',],
              admin_server: 'kerberos.mit.edu',
              master_kdc: 'kerberos.mit.edu',
              default_domain: 'mit.edu',
            },
            'EXAMPLE.COM': {
              kdc: ['kerberos.example.com', 'kerberos-1.example.com'],
              admin_server: 'kerberos.example.com',
            },
          },
          domain_realm: {
            '.mit.edu': 'ATHENA.MIT.EDU',
            'mit.edu': 'ATHENA.MIT.EDU',
          },
          capaths: {
            'ATHENA.MIT.EDU': {
              'EXAMPLE.COM': '.',
            },
            'EXAMPLE.COM': {
              'ATHENA.MIT.EDU': '.',
            },
          },
        }
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('krb5::client::install') }
      it { is_expected.to contain_class('krb5::client::config') }
      it { is_expected.to contain_package(package_name) }
      it { is_expected.to contain_krb5_config('libdefaults/default_realm').with(value: 'ATHENA.MIT.EDU') }
      it { is_expected.to contain_krb5_config('libdefaults/default_tgs_enctypes') }
      it { is_expected.to contain_krb5_config('libdefaults/default_tkt_enctypes') }
      it { is_expected.to contain_krb5_config('libdefaults/dns_lookup_kdc') }
      it { is_expected.to contain_krb5_config('libdefaults/dns_lookup_realm') }
      it { is_expected.to contain_krb5_config('realms/ATHENA.MIT.EDU') }
      it { is_expected.to contain_krb5_config('realms/EXAMPLE.COM') }
      it { is_expected.to contain_krb5_config('domain_realm/.mit.edu').with(value: 'ATHENA.MIT.EDU') }
      it { is_expected.to contain_krb5_config('domain_realm/mit.edu').with(value: 'ATHENA.MIT.EDU') }
      it { is_expected.to contain_krb5_config('capaths/ATHENA.MIT.EDU') }
      it { is_expected.to contain_krb5_config('capaths/EXAMPLE.COM') }
    end
  end
end
