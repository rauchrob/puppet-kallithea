require 'spec_helper'

describe 'kallithea::install' do
  let(:facts) {{ 
    :osfamily => 'Debian',
    :operatingsystem => 'Ubuntu',
  }}

  default_params = { 
    :manage_python => true,
    :app_root => '/app/root',
    :app_user => 'myuser',
    :ldap_support => true,
    :repo_root => '/repo/root',
    :service_provider => 'init',
  }

  context "with default params" do
    let(:params) { default_params }

    it { is_expected.to contain_kallithea__package('python-ldap') }
    it { is_expected.to contain_file('/etc/init.d/kallithea') }
    it { is_expected.to contain_class('python').with_virtualenv('true') }
    it { is_expected.not_to contain_class('git') }
    it { is_expected.not_to contain_file('/app/root/rcextensions/__init__.py') }
  end

  context "with service_provider = 'systemd'" do
    let(:params) { default_params.merge({ :service_provider => 'systemd' }) }

    it { is_expected.to contain_file('/etc/systemd/system/kallithea.service').with_ensure(:file) }
    it { is_expected.to contain_file('/etc/init.d/kallithea').with_ensure(:absent) }
    it { is_expected.not_to contain_file('/var/log/kallithea') }
  end

  context "with service_provider = 'init'" do
    let(:params) { default_params.merge({ :service_provider => 'init' }) }

    it { is_expected.to contain_file('/etc/systemd/system/kallithea.service').with_ensure(:absent) }
    it { is_expected.to contain_file('/etc/init.d/kallithea').with_ensure(:file) }
    it { is_expected.to contain_file('/var/log/kallithea') }
  end

  context "with ldap_support = false" do
    let(:params) { default_params.merge({ :ldap_support => false }) }

    it { is_expected.not_to contain_kallithea__package('python-ldap') }
  end

  context "with manage_git = true" do
    let(:params) { default_params.merge({ :manage_git => true }) }

    it { is_expected.to contain_class('git').that_comes_before('Class[kallithea::install]') }
  end

  context "with version = 'x.y.z'" do
    let(:params) { default_params.merge({ :version => 'x.y.z' }) }

    it { is_expected.to contain_kallithea__package('kallithea').with_ensure('x.y.z') }
  end

  context "with rcextensions = 'foobar'" do
    let(:params) { default_params.merge({ :rcextensions => 'foobar'}) }

    it { is_expected.to contain_file('/app/root/rcextensions/__init__.py').with_content('foobar') }
  end

end
