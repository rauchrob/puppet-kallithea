define kallithea::ini_setting (
  $setting,
  $value,
  $ensure = present,
  $section = undef,
) {
  validate_string(
    $setting,
    $value,
  )

  if $section {
    validate_string($section)
  }

  ini_setting { "kallithea ini_setting ${title}":
    ensure  => $ensure,
    path    => $kallithea::config::config_file,
    section => $section,
    setting => $setting,
    value   => $value,
    require => Exec['initialize kallithea config'],
    notify  => Service['kallithea'],
  }

}

