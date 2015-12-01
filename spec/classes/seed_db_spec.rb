require 'spec_helper'

describe 'kallithea::seed_db' do
  let(:facts) {{ 
    :osfamily => 'Debian',
    :operatingsystem => 'Ubuntu',
  }}

  context "with app_user => 'kallithea'" do
    let(:params) {{ :app_user => 'kallithea' }}

    it { is_expected.to contain_exec('kallithea_seed_db').with_user('kallithea') }
  end


end
