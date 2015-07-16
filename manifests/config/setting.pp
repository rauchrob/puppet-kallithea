define kallithea::config::setting (
  $value,
) {
  validate_string($title)
  validate_re($title, '.+/.+')

  $split = split($title, '/')
  $section = $split[0]
  $key = $split[1]

  augeas { "kallithea::config ${title}":
    lens    => 'Puppet.lns',
    incl    => $kallithea::config::config_file,
    changes => [
      "set ${section}/${key} '${value}'",
    ]
  }
}

