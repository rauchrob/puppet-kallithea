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

    it { should contain_kallithea__package('python-ldap') }
    it { should contain_file('/etc/init.d/kallithea') }
    it { should contain_class('python').with_virtualenv('true') }
    it { should_not contain_class('git') }
    it { should_not contain_file('/app/root/rcextensions/__init__.py') }
  end

  context "with service_provider = 'systemd'" do
    let(:params) { default_params.merge({ :service_provider => 'systemd' }) }

    it { should contain_file('/etc/systemd/system/kallithea.service').with_ensure(:file) }
    it { should contain_file('/etc/init.d/kallithea').with_ensure(:absent) }
    it { should_not contain_file('/var/log/kallithea') }
  end

  context "with service_provider = 'init'" do
    let(:params) { default_params.merge({ :service_provider => 'init' }) }

    it { should contain_file('/etc/systemd/system/kallithea.service').with_ensure(:absent) }
    it { should contain_file('/etc/init.d/kallithea').with_ensure(:file) }
    it { should contain_file('/var/log/kallithea') }
  end

  context "with ldap_support = false" do
    let(:params) { default_params.merge({ :ldap_support => false }) }

    it { should_not contain_kallithea__package('python-ldap') }
  end

  context "with manage_git = true" do
    let(:params) { default_params.merge({ :manage_git => true }) }

    it { should contain_class('git').that_comes_before('Class[kallithea::install]') }
  end

  context "with version = 'x.y.z'" do
    let(:params) { default_params.merge({ :version => 'x.y.z' }) }

    it { should contain_kallithea__package('kallithea').with_version('x.y.z') }
  end

  context "with rcextensions = 'foobar'" do
    let(:params) { default_params.merge({ :rcextensions => 'foobar'}) }

    it { should contain_file('/app/root/rcextensions/__init__.py').with_content('foobar') }
  end

end
