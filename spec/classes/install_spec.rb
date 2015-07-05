require 'spec_helper'

describe 'kallithea::install' do
  let(:facts) {{ :osfamily => 'Debian' }}

  default_params = { 
    :manage_python => false,
    :app_root => '/app/root',
    :app_user => 'myuser',
    :ldap_support => true,
    :repo_root => '/repo/root',
  }

  context "with default params" do
    let(:params) { default_params }

    it { should contain_kallithea__package('python-ldap') }
    it { should contain_file('/etc/init.d/kallithea') }
    it { should_not contain_class('python') }
  end

  context "with service_provider = 'systemd'" do
    let(:params) { default_params.merge({ :service_provider => 'systemd' }) }

    it { should contain_file('/etc/systemd/system/kallithea.service') }
  end

  context "with ldap_support = false" do
    let(:params) { default_params.merge({ :ldap_support => false }) }

    it { should_not contain_kallithea__package('python-ldap') }
  end

  context "with manage_python = true" do
    let(:params) { default_params.merge({ :manage_python => true }) }

    it { should contain_class('python').that_comes_before('Python::Virtualenv[/app/root/venv]') }
  end

end
