require 'spec_helper'

describe 'logstash::java_package' do
  let :default_params do
    {
      :java_package_ensure => 'installed'
    }
  end

  shared_examples_for 'logstash::java_package' do
    describe 'with default params' do
      it { should contain_package('java-1.7').with(
        :ensure => 'installed',
        :name   => platform_params[:java_package_name]
      )}
    end

    describe 'with parameters overridden' do
      let :params do
        default_params.merge!({
                                :java_package_name => 'sun-java-thing',
                                :java_package_ensure => 'latest'
                              })
      end
      it { should contain_package('java-1.7').with(
        :ensure => 'latest',
        :name   => 'sun-java-thing'
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
        :java_package_name => 'java-1.7.0-openjdk',
      }
    end
    it_configures 'logstash::java_package'
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
        :java_package_name => 'java-1.7.0-openjdk',
      }
    end

    it_configures 'logstash::java_package'
  end
end
