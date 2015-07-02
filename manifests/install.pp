# == Class kallithea::install
#
# This class is called from kallithea for install.
#
class kallithea::install {

  $packages = $::kallithea::ldap_support ? {
    true  => ['gcc', 'openldap-devel'],
    false => ['gcc'],
  }

  ensure_packages($packages)

  user { $::kallithea::app_user:
    ensure => present,
    home   => $::kallithea::app_root,
    system => true,
  }

  file { [ $::kallithea::app_root, $::kallithea::repo_root, ]:
    ensure => directory,
    owner  => $::kallithea::app_user,
    group  => $::kallithea::app_user,
  }

  file { '/var/log/kallithea':
    ensure => directory,
    owner  => $::kallithea::app_user,
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

  python::virtualenv { "${::kallithea::app_root}/venv":
    systempkgs => false,
    owner      => $::kallithea::app_user,
    group      => $::kallithea::app_user,
    require    => [
      User[$::kallithea::app_user],
      Package[$packages],
    ],
  }

  # Installing the 'PasteScript' before the 'kallithea' package
  # as workaround for easy_install not using our internal PyPi.
  # (see https://pip.pypa.io/en/latest/reference/pip_install.html#controlling-setup-requires)

  kallithea::package { 'PasteScript': } ->
  kallithea::package { 'kallithea': }

  if $::kallithea::ldap_support {
    kallithea::package { 'python-ldap': }
  }

}
