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
      it { is_expected.to be_running }
      # the following will fail if using simple init script on systems using upstart
      it { is_expected.to be_enabled }
    end

    describe port(5000) do
      it { should be_listening }
    end

    describe command('curl -I localhost:5000 2> /dev/null | head -n1') do
      its(:exit_status) { should eq 0 }
      its(:stdout) { should eq "HTTP/1.1 200 OK\n" }
    end

    describe command('puppet resource service kallithea ensure=stopped') do
      its(:exit_status) { should eq 0 }
    end
    
    describe port(5000) do
      it { 
        sleep(5)
        should_not be_listening
      }
    end

    describe command('puppet resource service kallithea ensure=running') do
      its(:exit_status) { should eq 0 }
    end
    
    describe port(5000) do
      it {
        sleep(10)
        should be_listening
      }
    end

  end
end
