# == Class: logstash::server
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
class logstash::server (
  $manage_package       = true,
  $manage_service       = true,
  $manage_repo          = true,
  $config_hash          = undef,
) inherits logstash::params {

  validate_bool($manage_repo)
  validate_bool($manage_package)
  validate_bool($manage_service)

  validate_string($service_ensure)
  validate_string($service_name)
  validate_string($package_name)

  if $manage_repo {
    if ! $manage_package {
      fail('$manage_package should be true if $manage_repo is true')
    }

    include logstash::repo
    if $manage_package {
      Class['logstash::repo'] -> Class['logstash::package']
    }
  }

  if $manage_package {
    include logstash::package
    if $manage_service {
      Class['logstash::package'] ~> Class['logstash::service']
    }
  }

  if $config_hash {
    class { 'logstash::config':
      config_hash     => $config_hash,
    }
  } else {
    notice('Not setting logstash config: no hash provided')
  }

  if $manage_service {
    include logstash::service
  }
}
