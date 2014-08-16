require 'spec_helper'

describe 'logstash::repo' do
  let :default_params do
    {
      :repo_hash => {}
    }
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

    describe 'with default params' do
      it { should contain_yumrepo('logstash').with(
        :baseurl    => platform_params['default_repo']['logstash']['baseurl'],
        :descr      => platform_params['default_repo']['logstash']['descr'],
        :gpgcheck   => platform_params['default_repo']['logstash']['gpgcheck'],
        :enabled    => platform_params['default_repo']['logstash']['enabled'],
        :gpgkey     => platform_params['default_repo']['logstash']['gpgkey']
      )}
    end

    describe 'with repo defaults overridden' do
      let :params do
        default_params.merge!({
                                :repo_defaults => {
                                  :proxy    => 'http://example.com:8000',
                                  :gpgcheck => '0'
                                }
                              })
      end
      it { should contain_yumrepo('logstash').with(
        :baseurl    => platform_params['default_repo']['logstash']['baseurl'],
        :descr      => platform_params['default_repo']['logstash']['descr'],
        :enabled    => platform_params['default_repo']['logstash']['enabled'],
        :gpgkey     => platform_params['default_repo']['logstash']['gpgkey'],
        :gpgcheck   => '0',
        :proxy      => 'http://example.com:8000'
      )}
    end

    describe 'with repo overridden' do
      let :params do
        default_params.merge!({
                                :repo_hash => {
                                  'test' => {
                                    :baseurl => 'http://example.com/centos',
                                    :descr   => 'test repo'
                                  }
                                }
                              })
      end

      it { should contain_yumrepo('test').with(
        :baseurl => 'http://example.com/centos',
        :descr   => 'test repo'
      )}
      it { should_not contain_yumrepo('logstash') }
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

    describe 'with default params' do
      it { should contain_apt__source('logstash').with(
        :location       => platform_params['default_repo']['logstash']['location'],
        :key_source     => platform_params['default_repo']['logstash']['key_source'],
        :release        => platform_params['default_repo']['logstash']['release'],
        :repos          => platform_params['default_repo']['logstash']['repos'],
      )}
    end

    describe 'with overridden repo' do
      let :params do
        default_params.merge!({
                                :repo_hash => {
                                  'test' => {
                                    :location   => 'http://example.com/debian',
                                    :release    => 'unstable'
                                    :repos      => 'updates'
                                  }
                                }
                              })
      end
      it { should contain_apt__source('test').with(
        :location       => platform_params['default_repo']['logstash']['location'],
        :release        => platform_params['default_repo']['logstash']['release'],
        :repos          => platform_params['default_repo']['logstash']['repos'],
      )}
      it { should_not contain_apt__source('logstash')}
    end
  end
end
