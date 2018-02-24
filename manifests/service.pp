# == Class kallithea::service
#
# This class is meant to be called from kallithea.
# It ensure the service is running.
#
class kallithea::service (
  $service_ensure = $::kallithea::params::service_ensure,
  $service_enable = $::kallithea::params::service_enable,
  $service_provider = $::kallithea::params::service_provider,
) inherits kallithea::params {
  service { 'kallithea':
    ensure   => $service_ensure,
    enable   => $service_enable,
    provider => $service_provider,
  }
}
