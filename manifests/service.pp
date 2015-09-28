# == Class kallithea::service
#
# This class is meant to be called from kallithea.
# It ensure the service is running.
#
class kallithea::service (
  $service_ensure = $::kallithea::service_ensure,
  $service_enable = $::kallithea::service_enable,
  $service_provider = $::kallithea::service_provider,
) {
  service { 'kallithea':
    ensure   => $service_ensure,
    enable   => $service_enable,
    provider => $service_provider,
  }
}
