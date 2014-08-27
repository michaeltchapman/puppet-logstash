# == Class logstash::params
#
# This class is meant to be called from logstash
# It sets variables according to platform
#
class logstash::params {
  case $::osfamily {
    'Debian': {
      $package_name = 'logstash'
      $forwarder_package_name = 'logstash-forwarder'
      $java_package_name = 'java-1.7.0-openjdk'
      $service_name = 'logstash'
      $forwarder_service_name = 'logstash-forwarder'
      $default_repo = {
                        'logstash' => {
                          'location'  => 'http://packages.elasticsearch.org/logstash/1.4/debian',
                          'key_source' => 'http://packages.elasticsearch.org/GPG-KEY-elasticsearch',
                          'release'    => 'stable',
                          'repos'      => 'main'
                        }
                      }
      $repo_defaults  = {}
    }
    'RedHat', 'Amazon': {
      $package_name = 'logstash'
      $forwarder_package_name = 'logstash-forwarder'
      $java_package_name = 'java-1.7.0-openjdk'
      $service_name = 'logstash'
      $forwarder_service_name = 'logstash-forwarder'
      $default_repo   = {
                          'logstash' => {
                            'descr'    => 'logstash repository for 1.4.x packages',
                            'baseurl'  => 'http://packages.elasticsearch.org/logstash/1.4/centos',
                            'gpgkey'   => 'http://packages.elasticsearch.org/GPG-KEY-elasticsearch'
                          }
                        }
      $repo_defaults  = {
                          'gpgcheck' => '1',
                          'enabled'  => '1'
                        }
    }
    default: {
      fail("${::osfamily} not supported")
    }
  }
}
