# == Class kallithea::config
#
# This class is called from kallithea for service config.
#
class kallithea::config (
  $app_user    = $::kallithea::app_user,
  $app_root    = $::kallithea::app_root,
  $config      = $::kallithea::config,
  $config_hash = $::kallithea::config_hash,
  $port        = $::kallithea::port,
) {

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

    require kallithea::config::initialize

    if $config_hash {
      $ini_settings = kallithea_config_hash_to_inifile_resources($config_hash)
      create_resources(kallithea::ini_setting, $ini_settings)
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

class kallithea::config::initialize {
  exec { 'initialize kallithea config':
    command => "/bin/sh -c \". ${app_root}/venv/bin/activate && paster make-config Kallithea kallithea.ini\"",
    cwd     => $::kallithea::config::app_root,
    creates => $::kallithea::config::config_file,
    user    => $::kallithea::config::app_user,
  }
}

