# == Class logstash::repo
#
# Manages logstash repository
#
class logstash::repo(
  $repo_hash     = undef,
  $repo_defaults = {}
) {

    if $repo_hash {
      $_repo_hash = $repo_hash
    } else {
      $_repo_hash = $logstash::params::default_repo
    }

    $_repo_defaults = merge($logstash::params::repo_defaults, $repo_defaults)

    case $::osfamily {
      'RedHat', 'Amazon': {
        create_resources('yumrepo', $_repo_hash, $repo_defaults)
      }
      'Debian': {
        create_resources('apt::source', $_repo_hash, $repo_defaults)
      }
      default: {
        warning("Repository has not been set as ${::osfamily} is not supported.")
      }
    }
}
