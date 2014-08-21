# == Class logstash::java_package
#
# Manage logstash java packages
#
class logstash::java_package (
  $java_package_name   = $::logstash::params::java_package_name,
  $java_package_ensure = 'installed'
) inherits logstash::params {

  package { 'java-1.7':
    ensure => $java_package_ensure,
    name   => $java_package_name,
  }
}
