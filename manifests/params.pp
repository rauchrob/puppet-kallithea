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
  $config = ''
  $ldap_support = true
  $manage_python = true
  $repo_root = "${app_root}/repos"
  $seed_db = false
  $service_enable = true
  $service_ensure = true

  case $::osfamily {
    /CentOS|RedHat/: {
      $packages = ['gcc']
      $ldap_packages = ['openldap-devel']
      $install_pip = false
      case $operatingsystemmajrelease {
        '7': {
          $service_provider = 'systemd'
        }
        default: {
          $service_provider = 'init'
          $service_template = 'kallithea/init.d/kallithea.redhat.erb'
        }
      }
    }
    'Debian': {
      $packages = []
      $install_pip = true
      $ldap_packages = ['libldap2-dev', 'libsasl2-dev']
      $service_provider = 'init'
      $service_template = 'kallithea/init.d/kallithea.debian.erb'
    }

    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
