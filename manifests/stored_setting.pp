# == Define kallithea::stored_setting
#
# This defined type is used to store $data in the yaml file created by the
# settings_store class. The $data's of different defines get (deeply) merged.

define kallithea::stored_setting (
  $data,
) {
  include kallithea::settings_store

  datacat_fragment { $title:
    target => $::kallithea::settings_store::file,
    data   => $data
  }
}

