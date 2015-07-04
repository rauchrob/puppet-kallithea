# == Class kallithea::install
#
# This class is called from kallithea for install.
#
class kallithea::install (
  $app_root      = $::kallithea::app_root,
  $app_user      = $::kallithea::app_user,
  $ldap_support  = $::kallithea::ldap_support,
  $manage_python = $::kallithea::manage_python,
  $repo_root     = $::kallithea::repo_root,
) {

  $packages = $ldap_support ? {
    true  => ['gcc', 'openldap-devel'],
    false => ['gcc'],
  }

  ensure_packages($packages)

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

  if $manage_python {
    class { 'python':
      dev        => true,
      pip        => false,
      virtualenv => true,
      before     => Python::Virtualenv["${app_root}/venv"],
    }
  }

  python::virtualenv { "${app_root}/venv":
    systempkgs => false,
    owner      => $app_user,
    group      => $app_user,
    require    => [
      User[$app_user],
      Package[$packages],
    ],
  }

  # Installing the 'PasteScript' before the 'kallithea' package
  # as workaround for easy_install not using our internal PyPi.
  # (see https://pip.pypa.io/en/latest/reference/pip_install.html#controlling-setup-requires)

  kallithea::package { 'PasteScript': } ->
  kallithea::package { 'kallithea': }

  if $ldap_support {
    kallithea::package { 'python-ldap': }
  }

}
