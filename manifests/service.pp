# == Class logstash::service
#
#
class logstash::service(
  $ensure = 'running',
  $enable = true
)
{
  service { 'logstash':
    ensure     => $ensure,
    name       => $logstash::params::service_name,
    enable     => $enable,
    hasstatus  => true,
    hasrestart => true
  }
}
