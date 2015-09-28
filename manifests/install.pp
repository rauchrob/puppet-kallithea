# == Class kallithea::install
#
# This class is called from kallithea for install.
#
class kallithea::install (
  $app_root         = $::kallithea::app_root,
  $app_user         = $::kallithea::app_user,
  $ldap_support     = $::kallithea::ldap_support,
  $manage_git       = $::kallithea::manage_git,
  $manage_python    = $::kallithea::manage_python,
  $repo_root        = $::kallithea::repo_root,
  $service_provider = $::kallithea::params::service_provider,
  $version          = $::kallithea::version,
) inherits kallithea::params {

  if $manage_git {
    require git
  } else {
    warning("the manage_git parameter will default to 'true' within rauch/kallithea v1.0.0")
  }

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

  case $service_provider {
    'systemd': {
      file { '/etc/systemd/system/kallithea.service':
        ensure  => file,
        mode    => '0644',
        content => template('kallithea/systemd/kallithea.service.erb'),
      }
    }
    'init': {
      file { '/etc/init.d/kallithea':
        ensure  => file,
        mode    => '0755',
        content => template($kallithea::params::service_template),
      }

      file { '/var/log/kallithea':
        ensure => directory,
        owner  => $app_user,
      }
    }
    default: { fail("service_provider ${service_provider} not supported") }
  }

  ############################################################
  # Python Setup

  $venv = "${app_root}/venv"

  if $manage_python {
    class { 'python':
      dev        => true,
      pip        => $::kallithea::params::install_pip,
      virtualenv => true,
    }
  }

  python::virtualenv { $venv:
    systempkgs => false,
    owner      => $app_user,
    group      => $app_user,
    # Workaround for https://github.com/stankevich/puppet-python/issues/215
    # Can be removed when support for stankevich/python <= 1.9.5 is dropped
    before     => Anchor['python::end'],
    require    => [
      User[$app_user],
    ],
  }

  # Normally, the `PasteScript` package is a `setup_requires`-dependency of
  # `kallithea`. This has the problem, that when we are behind a corporate proxy and using an
  # internal package index, pip still tries to contact PyPi for installing
  # `PasteScript`. As a workaround we do the following:
  kallithea::package { 'PasteScript': } ->

  kallithea::package { 'kallithea':
    version => $version,
  }

  package { $::kallithea::params::packages:
    ensure => present,
    before => Python::Virtualenv[$venv],
  }

  if $ldap_support {
    ensure_packages($::kallithea::params::ldap_packages)
    kallithea::package { 'python-ldap': }
  }

}
