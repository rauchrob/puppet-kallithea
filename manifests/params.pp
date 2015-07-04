# == Class kallithea::params
#
# This class is meant to be called from kallithea.
# It sets variables according to platform.
#
class kallithea::params {
  $admin_mail = "root@${::fqdn}"
  $admin_pass = 'adminpw'
  $admin_user = 'admin'
  $app_root = '/srv/kallithea'
  $app_user = 'kallithea'
  $config = undef
  $ldap_support = true
  $manage_python = true
  $repo_root = "${app_root}/repos"
  $seed_db = false
  $service_enable = true
  $service_ensure = true

  case $::osfamily {
    /CentOS|RedHat|Debian|Ubuntu/: {}
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
