# == Defined Type kallithea::package
#
# This type will install the python package named after the resource title into
# Kallitheas virtualenv.
#
define kallithea::package {

  $venv = "${::kallithea::app_root}/venv"

  python::pip { "${title}@${venv}":
    pkgname    => $title,
    virtualenv => $venv,
    owner      => $::kallithea::app_user,
    require    => Exec["python_virtualenv_${venv}"],
    notify     => Class['kallithea::service'],
  }

}
