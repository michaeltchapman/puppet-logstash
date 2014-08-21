require 'spec_helper'

describe 'logstash::server' do
  let :default_params do
    {
      :manage_package         => true,
      :manage_java_package    => true,
      :manage_service         => true,
      :manage_repo            => true,
    }
  end

  describe 'logstash::server' do
    let :facts do
    {
      :osfamily        => 'RedHat',
      :operatingsystem => 'CentOS'
    }
    end
    describe 'with default params' do
      it { should contain_class('logstash::repo')}
      it { should contain_class('logstash::package')}
      it { should contain_class('logstash::java_package')}
      it { should contain_class('logstash::service')}
    end

    describe 'with service disabled' do
    let :params do
      default_params.merge!({
                              :manage_service => false
                            })
    end
      it { should_not contain_class('logstash::service') }
    end

    describe 'with repo disabled' do
    let :params do
      default_params.merge!({
                              :manage_repo => false
                            })
    end
      it { should_not contain_class('logstash::repo') }
    end

    describe 'with package disabled' do
    let :params do
      default_params.merge!({
                              :manage_package => false
                            })
    end
      it { should_not contain_class('logstash::package') }
    end

    describe 'with java package disabled' do
    let :params do
      default_params.merge!({
                              :manage_java_package => false
                            })
    end
      it { should_not contain_class('logstash::java_package') }
    end

    describe 'with config provided' do
    let :params do
      default_params.merge!({
                              :config_hash => {'filename' => {'config_hash' => {'filter' => { 'set' => 'value'}}}}
                            })
    end
      it { should contain_class('logstash::config') }
    end
  end
end
