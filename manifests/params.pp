# == Class kallithea::params
#
# This class is meant to be called from kallithea.
# It sets variables according to platform.
#
class kallithea::params {
  case $::osfamily {
    'RedHat': {
      $app_user = 'kallithea'
      $app_root = '/srv/kallithea'
      $repo_root = "${app_root}/repos"
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
