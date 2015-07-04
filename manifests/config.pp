# == Class kallithea::config
#
# This class is called from kallithea for service config.
#
class kallithea::config (
  $app_user = $::kallithea::app_user,
  $app_root = $::kallithea::app_root,
  $config   = $::kallithea::config,
) {
  $config_file = "${app_root}/kallithea.ini"

  if $config {
    file { $config_file:
      owner   => $app_user,
      group   => $app_user,
      mode    => '0640',
      content => $config,
    }
  }
  else {
    exec { 'initialize kallithea config':
      command => "/bin/sh -c \"source ${app_root}/venv/bin/activate && paster make-config Kallithea kallithea.ini\"",
      cwd     => $app_root,
      creates => $config_file,
    } ->

    file { $config_file:
      owner => $app_user,
      group => $app_user,
      mode  => '0640',
    }
  }

}
