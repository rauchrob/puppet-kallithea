# == Class kallithea::service
#
# This class is meant to be called from kallithea.
# It ensure the service is running.
#
class kallithea::service {
  service { 'kallithea':
    ensure   => $::kallithea::service_ensure,
    enable   => $::kallithea::service_enable,
    provider => 'systemd',
  }
}
