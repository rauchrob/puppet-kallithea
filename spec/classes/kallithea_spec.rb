require 'spec_helper'

describe 'kallithea' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) { facts }

        context "kallithea class without any parameters" do
          it { is_expected.to compile.with_all_deps }
        end

      end
    end
  end

  context 'with default params' do
    let(:facts) { on_supported_os['centos-7-x86_64'] }

    it { is_expected.to contain_class('kallithea::params') }
    it { is_expected.to contain_class('kallithea::install').that_comes_before('kallithea::config') }
    it { is_expected.to contain_class('kallithea::config').that_notifies('kallithea::service') }
    it { is_expected.to contain_class('kallithea::service') }
    it { is_expected.to contain_class('kallithea::cron::whoosh').that_requires('kallithea::config') }
  end

  context 'with whoosh_cronjob => false' do
    let(:facts) { on_supported_os['centos-7-x86_64'] }
    let(:params) {{ 'whoosh_cronjob' => false }}

    it { is_expected.not_to contain_class('kallithea::cron::whoosh') }
  end

  context 'unsupported operating system' do
    describe 'kallithea class without any parameters on Solaris/Nexenta' do
      let(:facts) {{
        :osfamily        => 'Solaris',
        :operatingsystem => 'Nexenta',
      }}

      it { expect { is_expected.to contain_package('kallithea') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end
