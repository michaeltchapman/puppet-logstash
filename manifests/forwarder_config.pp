# == Class logstash::forwarder_config
#
# Set logstash forwarder configuration
#
# Hiera example:
#
class logstash::forwarder_config(
  $servers        = ['localhost'],
  $port           = 5000,
  $config_files   = [],
  $config_network = {}
) {
  file { '/etc/sysconfig/logstash-forwarder':
    group => 'root',
    owner => 'root',
    mode  => '0644',
    source => 'puppet:///modules/logstash/logstash-forwarder'
  } ~> Service<| title == 'logstash-forwarder' |>

  if $servers and $port {
    $_servers = suffix($servers, ":${port}")
  }

  $default_files = [
      {
        'paths' => [
          '/var/log/messages',
          '/var/log/*.log'
        ],
        'fields' => {
          'type' => 'syslog'
        }
      }
   ]

  if size($config_files) > 0 {
    $files = concat($default_files, $config_files)
  } else {
    $files = $default_files
  }

  $default_network = {
    'servers' => $_servers,
    'ssl ca'  => '/etc/pki/tls/certs/logstash-forwarder.crt',
    'timeout' => 15
  }

  $network = merge($default_network, $config_network)

  $default_config = {
    'network' => $network,
    'files'   => $files
  }

  $config = sorted_json($default_config)

  file { '/etc/logstash-forwarder':
    ensure => 'directory'
  } ->
  file { '/etc/logstash-forwarder/logstash-forwarder.conf':
    group => 'root',
    owner => 'root',
    mode  => '0644',
    content => $config
  } ~> Service<| title == 'logstash-forwarder' |>

}
