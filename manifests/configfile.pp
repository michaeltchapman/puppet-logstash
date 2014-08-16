# == Class logstash::config
#
# Set a logstash configuration based on a hash
# '_%_' can be used as a shorthand for %{literal('%')}
#
define logstash::configfile(
  $config_hash
) {
  validate_hash($config_hash)

  $_output = logstash_config($config_hash)
  $output = regsubst($_output, '_%_', '%', 'G')

  file { "logstash_configfile_${name}":
    ensure   => file,
    path     => "/etc/logstash/conf.d/${name}.conf",
    content  => $output,
    owner    => 'root',
    group    => 'root',
  }
}
