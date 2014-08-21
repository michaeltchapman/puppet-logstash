# == Class: logstash::server
#
# Full description of class logstash here.
#
# === Parameters
#
# [*manage_package*]
#   Whether to manage the logstash package
#
# [*manage_service*]
#   Whether to manage the logstash service
#
# [*manage_repo*]
#   Whether to manage the logstash repo
#
# [*config_hash*]
#   A hash of config files and their contents. See examples folder
#   for the format.
#
class logstash::server (
  $manage_package       = true,
  $manage_java_package  = true,
  $manage_service       = true,
  $manage_repo          = true,
  $config_hash          = undef,
) inherits logstash::params {

  validate_bool($manage_repo)
  validate_bool($manage_package)
  validate_bool($manage_java_package)
  validate_bool($manage_service)

  if $manage_repo {
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

  if $manage_java_package {
    include logstash::java_package
    if $manage_service {
      Class['logstash::java_package'] ~> Class['logstash::service']
    }
    if $manage_package {
      Class['logstash::java_package'] -> Class['logstash::package']
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
