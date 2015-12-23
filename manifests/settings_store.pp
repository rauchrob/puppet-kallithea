# == Class kallithea::settings_store
#
# This class will setup a yaml file for persisting some parameters the
# kallithea class has been called with. It is meant to be read by custom
# kallithea facts.

class kallithea::settings_store {
  $file = '/etc/kallithea.yml'

  datacat { $file:
    template => "${module_name}/settings_store.yml.erb",
  }

  kallithea::stored_setting { 'settings_store version':
    data => { 'metadata_version' => '1' },
  }
}

