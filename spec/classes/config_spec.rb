require 'spec_helper'

describe 'kallithea::config' do

  default_params = { 
    :app_root => '/app/root',
    :app_user => 'myuser',
  }

  config_file = '/app/root/kallithea.ini'

  context 'with default params' do
    let(:params) { default_params }

    it { is_expected.to contain_class('kallithea::config::initialize').that_comes_before('kallithea::config') }
    it { is_expected.to contain_exec('initialize kallithea config').with_user('myuser') }
    it { is_expected.not_to contain_file(config_file) }
  end

  context 'with config = "foo" set' do
    let(:params) { default_params.merge({ :config => 'foo' }) }

    it { is_expected.to contain_file(config_file).with_content('foo') }
    it { is_expected.not_to contain_exec(config_file) }
  end

  context 'with complex config_hash set' do
    let(:params) { default_params.merge({
      'config_hash' => {
        'sec1' => { 'key1' => 'val1', 'key2' => 'val2' },
        'sec2' => { 'key3' => 'val3' },
      }
    })}

    it { is_expected.to contain_ini_setting("#{config_file} [sec1] key1").with_value('val1') }
    it { is_expected.to contain_ini_setting("#{config_file} [sec1] key2").with_value('val2') }
    it { is_expected.to contain_ini_setting("#{config_file} [sec2] key3").with_value('val3') }
  end

  context 'with port = 1234 set' do
    let(:params) { default_params.merge({ :port => '1234' }) }

    it { is_expected.to contain_kallithea__ini_setting('server:main/port').with_value(1234) }
  end

end
