# == Class logstash::package
#
# Manage logstash packages
#
class logstash::package (
  $package_name        = $::logstash::params::package_name,
  $package_ensure      = 'installed',
  $java_package_name   = $::logstash::params::java_package_name,
  $java_package_ensure = 'installed'
) inherits logstash::params {
  package { 'logstash':
    ensure => $package_ensure,
    name   => $package_name,
  }

  package { 'java-1.7':
    ensure => $java_package_ensure,
    name   => $java_package_name,
  }
}
