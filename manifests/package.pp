# == Defined Type kallithea::package
#
# This type will install the python package named after the resource title into
# Kallitheas virtualenv.
#
define kallithea::package (
  $venv = $::kalllithea::install::venv,
  $version = undef,
) {

  if $version {
    $pkgname = "${title}==${version}"
  } else {
    $pkgname = $title
  }

  python::pip { "${title}@${venv}":
    pkgname    => $pkgname,
    virtualenv => $venv,
    owner      => $::kallithea::app_user,
    require    => Exec["python_virtualenv_${venv}"],
    notify     => Class['kallithea::service'],
  }

}
