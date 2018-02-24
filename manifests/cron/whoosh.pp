# == Class kallithea::cron::whoosh
#
# This class is meant to be called from kallithea.  It creates a cronjob for
# generating/refreshing the search index for Kallitheas Whoosh powered full
# text search.
#
class kallithea::cron::whoosh (
  $python_venv = $::kallithea::install::venv,
  $config_file = $::kallithea::config::config_file,
  $cron_params = {},
) {
  require kallithea::params

  $cron_command = "${python_venv}/bin/paster make-index ${config_file}"

  $cron_default_params = {
    user    => $kallithea::params::app_user,
    command => $cron_command,
    minute  => 5,
  }

  $cron_resources_hash = { 'regenerate Kallitheas whoosh index' => $cron_params }
  create_resources('cron', $cron_resources_hash, $cron_default_params)

}
