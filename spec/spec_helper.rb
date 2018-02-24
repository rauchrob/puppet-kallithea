require 'puppetlabs_spec_helper/module_spec_helper'
require 'rspec-puppet-facts'
include RspecPuppetFacts

RSpec.configure do |c|
    c.after(:suite) do RSpec::Puppet::Coverage.report!
    c.default_facts = {
      :virtualenv_version => '13.1.2',
      :osfamily => 'Debian',
      :operatingsystem => 'Ubuntu',
      :lsbdistcodename => 'xenial',
    }
end
