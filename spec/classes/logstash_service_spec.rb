require 'spec_helper'

describe 'logstash::service' do
  let :default_params do
    {
      :ensure => 'running',
      :enable => true
    }
  end

  shared_examples_for 'logstash::service' do
    describe 'with default params' do
      it { should contain_service('logstash').with(
        :name        => platform_params['service_name'],
        :ensure      => 'running',
        :enable      => true,
        :hasstatus   => true,
        :hasrestart => true
      )}
    end

    describe 'with parameters overridden' do
      let :params do
        default_params.merge!({
                                :ensure => 'stopped',
                                :enable => false
                              })
      end
      it { should contain_service('logstash').with(
        :name => platform_params['service_name'],
        :ensure => 'stopped',
        :enable => false
      )}
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
        'service_name'      => 'logstash',
      }
    end
    it_configures 'logstash::service'
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
        'service_name'      => 'logstash',
      }
    end

    it_configures 'logstash::service'
  end
end
