# == Class: kallithea::seed_db
#
# This class handles the initialization of the database backing kallithea.
# As this procedure will overwrite the existing database, we have taken
# measures to do this by accident. Thus, database initialization will be
# triggered only if
#
# 1. Class['kallithea::seed_db'] recieves a notify
# 2. There is no lockfile named '.db_initialized' in $app_root
#
# Once the database initialization is triggered, the lockfile will is created.
#
# === Parameters
#
# [*user*]
#   Name of the initial admin user. 
#
# [*pass*]
#   Password for the initial admin user.
#
# [*mail*]
#   Email of the initial admin user.
#

class kallithea::seed_db (
  $user = 'admin',
  $pass = 'adminpw',
  $mail = "kallithea@${::fqdn}",
) {
  
  # TODO: validate parameters

  $app_root = $::kallithea::app_root
  $repo_root = $::kallithea::repo_root
  $config_file = "${app_root}/kallithea.ini"
  $lock_file = "${app_root}/.db_initalized"

  $cmd = join( [
      "${app_root}/venv/bin/paster setup-db",
      "--user=${user} --password=${pass}",
      "--email=${mail} --repos=${repo_root}",
      "--force-yes ${config_file}",
      "&& touch ${lock_file}",
  ], ' ')

  exec { 'kallithea_seed_db':
    command     => $cmd,
    creates     => $lock_file,
    refreshonly => true,
  }
}

