define kallithea::ini_setting (
  $setting,
  $value,
  $ensure = present,
  $section = undef,
) {

  ini_setting { "kallithea ini_setting ${title}":
    ensure  => $ensure,
    path    => $kallithea::config::config_file,
    section => $section,
    setting => $setting,
    value   => $value,
  }

}

