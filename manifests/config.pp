# == Class logstash::config
#
# Set logstash configuration
#
# Hiera example:
#
# 01-lumberjack-input:
#   input:
#     lumberjack:
#       port:  5000
#       type: logs
#       ssl_certificate: /etc/pki/tls/certs/logstash-forwarder.crt
#
class logstash::config(
  $config_hash = {}
) {

  file { '/etc/logstash/':
    ensure => 'directory'
  } ->
  file { '/etc/logstash/conf.d':
    ensure => 'directory'
  }
  create_resources('logstash::configfile', $config_hash)
}
