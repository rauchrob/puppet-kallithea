# == Class kallithea::config
#
# This class is called from kallithea for service config.
#
class kallithea::config {
  $config_file = "${::kallithea::app_root}/kallithea.ini"

  if $::kallithea::config {
    file { $config_file:
      owner   => $::kallithea::app_user,
      group   => $::kallithea::app_user,
      mode    => '0640',
      content => $::kallithea::config,
    }
  }
  else {
    exec { 'initialize kallithea config':
      command => "/bin/sh -c \"source ${::kallithea::app_root}/venv/bin/activate && paster make-config Kallithea kallithea.ini\"",
      cwd     => $::kallithea::app_root,
      creates => $config_file,
    } ->

    file { $config_file:
      owner => $::kallithea::app_user,
      group => $::kallithea::app_user,
      mode  => '0640',
    }
  }

}
