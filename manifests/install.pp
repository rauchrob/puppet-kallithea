# == Class kallithea::install
#
# This class is called from kallithea for install.
#
class kallithea::install (
  $app_root         = $::kallithea::app_root,
  $app_user         = $::kallithea::app_user,
  $ldap_support     = $::kallithea::ldap_support,
  $manage_python    = $::kallithea::manage_python,
  $repo_root        = $::kallithea::repo_root,
  $service_provider = $::kallithea::params::service_provider,
) inherits params {

  user { $app_user:
    ensure => present,
    home   => $app_root,
    system => true,
  }

  file { [ $app_root, $repo_root, ]:
    ensure => directory,
    owner  => $app_user,
    group  => $app_user,
  }

  file { '/var/log/kallithea':
    ensure => directory,
    owner  => $app_user,
  }

  case $service_provider {
    'systemd': {
      file { '/usr/lib/systemd/system/kallithea.service':
        ensure  => file,
        mode    => '0644',
        content => template('kallithea/systemd/kallithea.service.erb'),
      }

      file { '/etc/systemd/system/kallithea.service':
        ensure => link,
        target => '/usr/lib/systemd/system/kallithea.service',
        notify => Service['kallithea'],
      }
    }
    'init': {
      file { '/etc/init.d/kallithea':
        ensure  => file,
        mode    => '0755',
        content => template('kallithea/init.d/kallithea.debian.erb'),
      }
    }
  }

  ############################################################
  # Python Setup

  $venv = "${app_root}/venv"

  if $manage_python {
    class { 'python':
      dev        => true,
      pip        => $::kallithea::params::install_pip,
      virtualenv => true,
      before     => Python::Virtualenv[$venv],
    }
  }

  python::virtualenv { $venv:
    systempkgs => false,
    owner      => $app_user,
    group      => $app_user,
    require    => [
      User[$app_user],
    ],
  }

  # Installing the 'PasteScript' before the 'kallithea' package
  # as workaround for easy_install not using our internal PyPi.
  # (see https://pip.pypa.io/en/latest/reference/pip_install.html#controlling-setup-requires)

  kallithea::package { 'PasteScript': } ->
  kallithea::package { 'kallithea': }

  package { $::kallithea::params::packages:
    ensure => present,
    before => Python::Virtualenv[$venv],
  }

  if $ldap_support {
    ensure_packages($::kallithea::params::ldap_packages)
    kallithea::package { 'python-ldap': }
  }

}
