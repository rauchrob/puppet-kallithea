require 'spec_helper'

describe 'kallithea::settings_store' do
  it { should contain_datacat('/etc/kallithea.yml') }
end
