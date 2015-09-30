require 'spec_helper'

describe 'kallithea::cron::whoosh' do

  default_params = { 
    :python_venv => '/app/venv',
    :config_file => '/my/kallithea.ini',
  }

  context 'with default params' do
    let(:params) { default_params }

    it { should contain_cron('regenerate Kallitheas whoosh index').with_command('/app/venv/bin/paster make-index /my/kallithea.ini').with_minute(5) }
  end

  context 'with various cron_params' do
    let(:params) { default_params.merge({ 'cron_params' => { 'minute' => 7, 'hour' => 5 }}) }

    it { should contain_cron('regenerate Kallitheas whoosh index').with_minute(7).with_hour(5) }
  end

end
