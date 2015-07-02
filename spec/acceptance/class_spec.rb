require 'spec_helper_acceptance'

describe 'kallithea class' do

  context 'default parameters and seed_db => true' do
    # Using puppet_apply as a helper
    it 'should work idempotently with no errors' do
      pp = <<-EOS
      class { 'kallithea':
        seed_db => true,
      }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes  => true)
    end

    describe service('kallithea') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end

    describe port(5000) do
      it { should be_listening }
    end

    describe command('curl localhost:5000 2>&1 | grep -iq kallithea') do
      its(:exit_status) { should eq 0 }
    end

  end
end
