# == Class: logstash
#
# Full description of class logstash here.
#
# === Parameters
#
# [*package_name*]
#   Name of the logstash package to use
#
# [*service_name*]
#   Name of the logstash service to manage
#
class logstash::forwarder (
  $manage_package       = true,
  $package_name         = $logstash::params::forwarder_package_name,
  $package_ensure       = 'installed',
  $manage_init          = true,
  $manage_service       = true,
  $service_enable       = true,
  $service_ensure       = 'running',
  $service_name         = $logstash::params::forwarder_service_name,
) inherits logstash::params {

  validate_bool($manage_package)
  validate_bool($manage_service)

  validate_string($service_ensure)
  validate_string($service_name)
  validate_string($package_name)

  if $manage_package {
    package { 'logstash_forwarder':
      ensure => $package_ensure,
      name   => $package_name
    } -> Service<| title == 'logstash_forwarder'|>
  }

  include logstash::forwarder_config

  if $manage_init {
    file { '/etc/init.d/logstash-forwarder':
      group    => 'root',
      owner    => 'root',
      mode     => '0755',
      source   => 'puppet:///modules/logstash/logstash_forwarder_redhat_init'
    } ~> Service<| title == 'logstash_forwarder' |>
  }

  if $manage_service {
    # The package doesn't include an init script, so if we're managing the
    service { 'logstash_forwarder':
      ensure => $service_ensure,
      enable => $service_enable,
      name   => $service_name
    }
  }
}
