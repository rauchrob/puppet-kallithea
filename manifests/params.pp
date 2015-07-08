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
  $manage_git = false
  $manage_python = true
  $repo_root = "${app_root}/repos"
  $seed_db = false
  $service_enable = true
  $service_ensure = true

  case $::osfamily {
    'RedHat': {
      $packages = ['gcc']
      $ldap_packages = ['openldap-devel']
      $install_pip = false
    }
    'Debian': {
      $packages = []
      $install_pip = true
      $ldap_packages = ['libldap2-dev', 'libsasl2-dev']
    }
  }

  # Service parameters
  case $::operatingsystem {
    /RedHat|CentOS/: {
      case $::operatingsystemmajrelease {
        '7': { $service_provider = 'systemd' }
        '6': {
          $service_provider = 'init'
          $service_template = 'kallithea/init.d/kallithea.redhat.erb'
        }
        default: { fail("${::operatingsystem}${::operatingsystemmajrelease} not supported") }
      }
    }
    /Fedora/: {
      case $::operatingsystemmajrelease {
        /19|20/: { $service_provider = 'systemd' }
        default: { fail("${::operatingsystem}${::operatingsystemmajrelease} not supported") }
      }
    }
    /Debian|Ubuntu/: {
      $service_provider = 'init'
      $service_template = 'kallithea/init.d/kallithea.debian.erb'
    }

    default: { fail("${::operatingsystem} not supported") }
  }
}
