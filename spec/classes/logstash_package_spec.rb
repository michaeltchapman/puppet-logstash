require 'spec_helper'

describe 'logstash' do
  let :default_params do
    {
    }
  end

  shared_examples for 'logstash' do
    describe 'with default params' do
    end

    describe 'with service disabled' do
      let :params do
        default_params.merge!({
                              })
      end
    end
  end

  context 'on Debian platforms' do
    let :facts do
      {
        :osfamily               => 'Debian',
        :operatingsystem        => 'Debian',
        :lsbdistid              => 'wheezy'
      }
    end

    let :platform_params do
      {
        :package_name      => 'logstash',
        :java_package_name => 'java-1.7.0-openjdk',
        :service_name      => 'logstash',
        :default_repo => {
          'logstash' => {
             'location'   => 'http://packages.elasticsearch.org/logstash/1.4/debian',
             'key_source' => 'http://packages.elasticsearch.org/GPG-KEY-elasticsearch',
             'release'    => 'stable',
             'repos'      => 'main' 
          }
        }
      }
    end
    it_configures 'logstash'
  end

  context 'on RedHat platforms' do
    let :facts do
      {
        :osfamily               => 'RedHat',
        :operatingsystem        => 'RedHat',
        :operatingsystemrelease => '6.5'
      }
    end

    let :platform_params do
      {
        :package_name      => 'logstash',
        :java_package_name => 'java-1.7.0-openjdk',
        :service_name      => 'logstash',
        :default_repo      => {
          'logstash' => {
             'name'     => 'logstash repository for 1.4.x packages',
             'baseurl'  => 'http://packages.elasticsearch.org/logstash/1.4/centos',
             'gpgcheck' => '1',
             'enabled'  => '1',
             'gpgkey'   => 'http://packages.elasticsearch.org/GPG-KEY-elasticsearch'
          }
        }
      }
    end

    it_configures 'logstash'
  end
end
