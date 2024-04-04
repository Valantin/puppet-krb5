# @summary
class krb5::client::install {
  package { $krb5::client::package:
    ensure => $krb5::client::package_version,
  }
}
