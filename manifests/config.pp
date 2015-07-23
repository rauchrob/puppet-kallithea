# == Class kallithea::config
#
# This class is called from kallithea for service config.
#
class kallithea::config (
  $app_user    = $::kallithea::app_user,
  $app_root    = $::kallithea::app_root,
  $config      = $::kallithea::config,
  $config_hash = $::kallithea::config_hash,
) {

  $config_file = "${app_root}/kallithea.ini"

  if $config {
    if $config_hash {
      warning('$config given, ignoring $config_hash parameter.')
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
      command => "/bin/sh -c \". ${app_root}/venv/bin/activate && paster make-config Kallithea kallithea.ini\"",
      cwd     => $app_root,
      creates => $config_file,
      user    => $app_user,
    }

    if $config_hash {
      $ini_settings = kallithea_config_hash_to_inifile_resources($config_hash)
      create_resources(kallithea::ini_setting, $ini_settings)
    }

  }
}
