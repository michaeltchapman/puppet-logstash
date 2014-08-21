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
  $manage_service       = true,
  $service_enable       = true,
  $service_ensure       = 'running',
  $service_name         = $logstash::params::forwarder_service_name,
  $manage_repo          = true,
  $repo_hash            = {},
  $config_hash          = undef
) inherits logstash::params {

  validate_bool($manage_repo)
  validate_bool($manage_package)
  validate_bool($manage_service)

  validate_string($service_ensure)
  validate_string($service_name)
  validate_string($package_name)

  if $manage_repo {
    ensure_resource('class', 'logstash::repo', {'repo_hash' => $repo_hash})
    Class['logstash::repo'] -> Package<| title == 'logstash_forwarder' |>
  }

  if $manage_package {
    package { 'logstash_forwarder':
      ensure => $package_ensure,
      name   => $package_name
    } -> Service<| title == 'logstash_forwarder'|>
  }

  class { 'logstash::forwarder_config':
    config_hash => $config_hash
  }

  if $manage_service {
    service { 'logstash_forwarder':
      ensure => $service_ensure,
      enable => $service_enable,
      name   => $service_name
    }
  }
}
