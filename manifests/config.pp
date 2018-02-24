# == Class kallithea::config
#
# This class is called from kallithea for service config.
#
class kallithea::config (
  $app_user    = $::kallithea::params::app_user,
  $app_root    = $::kallithea::params::app_root,
  $config      = $::kallithea::params::config,
  $config_hash = $::kallithea::params::config_hash,
  $listen_ip   = $::kallithea::params::listen_ip,
  $port        = $::kallithea::params::port,
) inherits kallithea::params {

  $config_file = "${app_root}/kallithea.ini"

  if $config {
    if $config_hash {
      warning('$config given, ignoring $config_hash parameter.')
    }

    if $port {
      warning('$config given, ignoring $port parameter.')
    }

    file { $config_file:
      owner   => $app_user,
      group   => $app_user,
      mode    => '0640',
      content => $config,
      notify  => Service['kallithea'],
    }
  } else {

    exec { 'initialize kallithea config':
      command => "${app_root}/venv/bin/paster make-config Kallithea kallithea.ini",
      cwd     => $app_root,
      creates => $config_file,
      user    => $app_user,
    }

    if $config_hash {
      $config_ini_defaults = {
        path    => $config_file,
        require => Exec['initialize kallithea config'],
      }
      create_ini_settings($config_hash, $config_ini_defaults)
    }

    if $listen_ip {
      kallithea::ini_setting { 'server:main/host':
        section => 'server:main',
        setting => 'host',
        value   => $listen_ip,
      }
    }

    if $port {
      kallithea::ini_setting { 'server:main/port':
        section => 'server:main',
        setting => 'port',
        value   => $port,
      }
    }
  }
}
