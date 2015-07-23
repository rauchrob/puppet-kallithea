define kallithea::ini_setting (
  $ensure = present,
  $section = undef,
  $setting,
  $value,
) {

  ini_setting { "kallithea ini_setting ${title}":
    ensure  => $ensure,
    path    => $kallithea::config::config_file,
    section => $section,
    setting => $setting,
    value   => $value,
  }

}

