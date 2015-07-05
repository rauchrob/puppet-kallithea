require 'spec_helper'

describe 'kallithea' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "kallithea class without any parameters" do
          it { is_expected.to compile.with_all_deps }
        end

      end
    end
  end

  context 'in all cases' do
    let(:facts) {{ :osfamily => 'Debian' }}

    it { is_expected.to contain_class('kallithea::params') }
    it { is_expected.to contain_class('kallithea::install').that_comes_before('kallithea::config') }
    it { is_expected.to contain_class('kallithea::config') }
  end

  context 'unsupported operating system' do
    describe 'kallithea class without any parameters on Solaris/Nexenta' do
      let(:facts) {{
        :osfamily        => 'Solaris',
        :operatingsystem => 'Nexenta',
      }}

      it { expect { is_expected.to contain_package('kallithea') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end
