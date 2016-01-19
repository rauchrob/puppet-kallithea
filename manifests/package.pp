# == Defined Type kallithea::package
#
# This type will install the python package named after the resource title into
# Kallitheas virtualenv.
#
define kallithea::package (
  $ensure = present,
  $url = undef,
) {
  $venv = $::kallithea::install::venv

  python::pip { "${title}@${venv}":
    ensure       => $ensure,
    pkgname      => $title,
    url          => $url,
    install_args => '--upgrade',
    virtualenv   => $venv,
    owner        => $::kallithea::app_user,
    require      => Exec["python_virtualenv_${venv}"],
    notify       => Class['kallithea::service'],
  }
}
