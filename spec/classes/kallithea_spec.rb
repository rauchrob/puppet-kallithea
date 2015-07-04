require 'spec_helper'

describe 'kallithea' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        app_root = '/srv/kallithea'

        context "kallithea class without any parameters" do
          let(:params) {{ }}

          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('kallithea::params') }
          it { is_expected.to contain_class('kallithea::install').that_comes_before('kallithea::config') }
          it { is_expected.to contain_class('kallithea::config') }

          it { is_expected.to contain_file("#{app_root}/kallithea.ini").with_content(nil) }
          it { should contain_python__pip("python-ldap@#{app_root}/venv") }
          it { is_expected.to contain_class('python').that_comes_before("Python::Virtualenv[#{app_root}/venv]") }
        end

        context "kallithea class with config parameter" do
          let(:params) {{ :config => 'foo' }}

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_file("#{app_root}/kallithea.ini").with_content('foo') }
        end

        context "kallithea class without ldap_support" do
          let(:params) {{ :ldap_support => false }}

          it { is_expected.to compile.with_all_deps }
          it { should_not contain_package('openldap-devel') }
        end

        context "kallithea class with manage_python = false " do
          let(:params) {{ :manage_python => false }}

          it { is_expected.to compile.with_all_deps }
          it { should_not contain_class('python') }
        end
      end
    end
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
