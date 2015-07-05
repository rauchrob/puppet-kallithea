require 'spec_helper'

describe 'kallithea::config' do

  default_params = { 
    :app_root => '/app/root',
    :app_user => 'myuser',
  }

  context 'with default params' do
    let(:params) { default_params }
    it { should contain_exec('initialize kallithea config') }
  end

  context 'with config = "foo" set' do
    let(:params) { default_params.merge({ :config => 'foo' }) }
    it { should contain_file('/app/root/kallithea.ini').with_content('foo') }
  end

end
