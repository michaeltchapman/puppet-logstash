# == Class logstash::package
#
# Manage logstash packages
#
class logstash::package (
  $package_name        = $::logstash::params::package_name,
  $package_ensure      = 'installed',
) inherits logstash::params {
  package { 'logstash':
    ensure => $package_ensure,
    name   => $package_name,
  }
}
