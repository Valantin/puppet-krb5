# @summary
class krb5::client::config {
  $krb5::client::libdefaults.each |$_k,$_v| {
    krb5_config { "libdefaults/${_k}":
      setting => $_k,
      value   => $_v,
    }
  }

  $krb5::client::realms.each |$_k,$_v| {
    krb5_config { "realms/${_k}":
      setting => $_k,
      value   => $_v,
    }
  }

  $krb5::client::domain_realm.each |$_k,$_v| {
    krb5_config { "domain_realm/${_k}":
      setting => $_k,
      value   => $_v,
    }
  }

  $krb5::client::capaths.each |$_k,$_v| {
    krb5_config { "capaths/${_k}":
      setting => $_k,
      value   => $_v,
    }
  }

  $krb5::client::appdefaults.each |$_k,$_v| {
    krb5_config { "appdefaults/${_k}":
      setting => $_k,
      value   => $_v,
    }
  }
  $krb5::client::plugins.each |$_k,$_v| {
    krb5_config { "plugins/${_k}":
      setting => $_k,
      value   => $_v,
    }
  }
}
