# @summary
#
#
class krb5::client (
  String[1] $package,
  String[1] $package_version = installed,
  Hash $libdefaults = {},
  Hash $realms = {},
  Hash $domain_realm = {},
  Hash $capaths = {},
  Hash $appdefaults = {},
  Hash $plugins = {},
) {
  contain krb5::client::install
  contain krb5::client::config
  Class['krb5::client::install'] -> Class['krb5::client::config']
}
