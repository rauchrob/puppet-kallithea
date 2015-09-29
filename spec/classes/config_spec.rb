require 'spec_helper'

describe 'kallithea::config' do

  default_params = { 
    :app_root => '/app/root',
    :app_user => 'myuser',
  }

  context 'with default params' do
    let(:params) { default_params }

    it { should contain_exec('initialize kallithea config').with_user('myuser') }
    it { should_not contain_file('/app/root/kallithea.ini') }
  end

  context 'with config = "foo" set' do
    let(:params) { default_params.merge({ :config => 'foo' }) }

    it { should contain_file('/app/root/kallithea.ini').with_content('foo') }
    it { should_not contain_exec('initialize kallithea config') }
  end

  context 'with complex config_hash set' do
    let(:params) { default_params.merge({
      'config_hash' => {
        'sec1' => { 'key1' => 'val1', 'key2' => 'val2' },
        'sec2' => { 'key3' => 'val3' },
      }
    })}

    it { should contain_kallithea__ini_setting('sec1/key1').with_value('val1') }
    it { should contain_kallithea__ini_setting('sec1/key2').with_value('val2') }
    it { should contain_kallithea__ini_setting('sec2/key3').with_value('val3') }
  end

  context 'with port = 1234 set' do
    let(:params) { default_params.merge({ :port => '1234' }) }

    it { should contain_kallithea__ini_setting('server:main/port').with_value(1234) }
  end

end
