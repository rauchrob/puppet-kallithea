require 'spec_helper_acceptance'

describe 'kallithea class' do

  if ENV.has_key?('KALLITHEA_VERSION')
    kallithea_version = ENV['KALLITHEA_VERSION']
    kallithea_version_string = "'#{ENV['KALLITHEA_VERSION']}'"
  else
    kallithea_version = nil
    kallithea_version_string = "undef"
  end

  context 'default parameters and manage_git, seed_db => true' do
    # Using puppet_apply as a helper
    it 'should work idempotently with no errors' do
      pp = <<-EOS
      class { 'kallithea':
        seed_db     => true,
        manage_git  => true,
        version     => #{kallithea_version_string},
      }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes  => true)
    end

    # the puppetlabs/git module <=0.4.0 does not officially support Fedora, so
    # we do some rudimentary testing here:
    describe command('git --version') do
      its(:exit_status) { should eq 0 }
    end

    describe file('/srv/kallithea/kallithea.db') do
      it { should be_owned_by 'kallithea' }
    end

    describe service('kallithea') do
      it { is_expected.to be_running }
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

    describe command('/srv/kallithea/venv/bin/pip show kallithea') do
      its(:exit_status) { should eq 0 }
      if kallithea_version
        its(:stdout) { should match /^Version: #{kallithea_version}$/ }
      end
    end
  end

  context 'change configuration with config_hash parameter' do
    # Using puppet_apply as a helper
    it 'should work idempotently with no errors' do
      pp = <<-EOS
      class { 'kallithea':
        config_hash => {
          'server:main' => {
            'port' => '12345',
          },
          'DEFAULT' => {
            'smtp_port' => '25',
          }
        }
          
      }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes  => true)
    end

    describe port(12345) do
      it {
        sleep(10)
        should be_listening
      }
    end
  end

  context 'change configuration with port parameter' do
    # Using puppet_apply as a helper
    it 'should work idempotently with no errors' do
      pp = <<-EOS
      class { 'kallithea':
        port => 1234,
      }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes  => true)
    end

    describe port(1234) do
      it {
        sleep(10)
        should be_listening
      }
    end
  end

  context 'downgrading to kallithea v0.2.1' do
    # Using puppet_apply as a helper
    it 'should work idempotently with no errors' do
      pp = <<-EOS
      class { 'kallithea':
        version => '0.2.1',
      }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes  => true)
    end

    describe command('/srv/kallithea/venv/bin/pip show kallithea') do
      its(:stdout) { should match /^Version: 0.2.1$/ }
    end

  end

end
