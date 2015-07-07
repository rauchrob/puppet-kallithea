require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'

# Initial provisioning
unless ENV['BEAKER_provision'] == 'no'
  install_puppet_on(hosts, { version: ENV['PUPPET_VERSION'] } )
end

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    # Install module and dependencies
    puppet_module_install(:source => proj_root, :module_name => 'kallithea')
    on hosts, puppet('module', 'install', 'stankevich/python'), { :acceptable_exit_codes => [0,1] }
  end
end
