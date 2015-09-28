# == Class: kallithea
#
# This class manages the installation and configuration of a Kallithea app
# root. It is meant to be used in conjunction with an application server 
# (e.g. Phusion Passenger), a web server and a database server.
#
# === Parameters
#
# [*app_user*]
#   The user under which kallithea will be installed. Defaults to 'kallithea'.
#
# [*app_root*]
#   The directory under which kallithea will be installed (i.e. the home
#   directory of '$app_user'). Defaults to '/srv/kallithea'.
#
# [*repo_root*]
#   The directory under which kallithea will put the repositories. Defaults
#   to "${app_root}/repos".
#
# [*proxy*]
#   If not 'undef', this will be the HTTP proxy settings which are used when
#   installing kallithea via pip. Defaults to 'undef'.
#
# [*config*]
#   If not 'undef', this will the content of kallitheas main configuration
#   file "${app_root}/kallithea.ini". Otherwise, it will be initialized with
#   kallitheas defaults during installation.
#
# [*config_hash*]
#   A hash of strings, used to add or update Kallitheas default INI-style
#   configuration file. Keys correspond to sections the values, which must be
#   string valued hashes of strings, correspond to key/value pairs within that
#   section. For example,
#
#     $config_hash => {
#       'DEFAULT'  => {
#         'key1'   => 'value1',
#         'key2'   => 'value2',
#       }
#     }
#   
#   will create two settings 'key1 = value1' and 'key = value2' withing the
#   DEFAULT section of Kallitheas configuration file.
#
#   This parameter Will be ignored, if the $config parameter has been given.
#
# [*ldap_support*]
#   If set to true, the python-ldap package and its dependencies will be
#   installed into kallitheas python environment.
#
# [*service_ensure*]
#   Whether to start kallithea as a service.
#
# [*service_enable*]
#   Whether to enable the kallithea service on boot.
#
# [*service_enable*] Set to override Puppets default service provider in the
#   definition of the Kallithea service.
#
# [*seed_db*]
#   Whether to initialize kallitheas database during installation. A lockfile
#   is created to prevent subsequent database resets (see documentation of the
#   kallithea::seed_db class).
#
# [*admin_user*]
#   Name of the initial admin user, created during database initialization.
#
# [*admin_pass*]
#   Password of the initial admin user, created during database initialization.
#
# [*admin_mail*]
#   Mail of the initial admin user, created during database initialization.
#
# [*manage_python*]
#   Whether to manage installation of Python and required tools (virtualenv and
#   pip). Needs the stankevich/python module
#
# [*manage_git*]
#   Whether to manage installation of git by using the puppetlabs/git module.
#
# [*version*]
#   The version of Kallithea to installed. If undef, the latest available version
#   will be used.
#
# [*rcextensions*]
#   Setup custom rcextensions package with provided content.
#
class kallithea (
  $admin_mail = $kallithea::params::admin_mail,
  $admin_pass = $kallithea::params::admin_pass,
  $admin_user = $kallithea::params::admin_user,
  $app_root = $kallithea::params::app_root,
  $app_user = $kallithea::params::app_user,
  $config = $kallithea::params::config,
  $config_hash = $kallithea::params::config_hash,
  $ldap_support = $kallithea::params::ldap_support,
  $manage_git = $kallithea::params::manage_git,
  $manage_python = $kallithea::params::manage_python,
  $rcextensions = $kallithea::params::rcextensions,
  $repo_root = $kallithea::params::repo_root,
  $seed_db = $kallithea::params::seed_db,
  $service_enable = $kallithea::params::service_enable,
  $service_ensure = $kallithea::params::service_ensure,
  $service_provider = $kallithea::params::service_provider,
  $version = $kallithea::params::version,
) inherits kallithea::params {

  ##################################################
  # Data Validation

  validate_string(
    $app_user,
    $admin_user,
    $admin_pass,
    $admin_mail,
    $rcextensions,
    $version,
  )
  validate_absolute_path([$app_root, $repo_root])
  validate_bool(
    $ldap_support,
    $manage_python,
    $seed_db,
    $service_enable,
    $service_ensure,
  )

  if $config {
    validate_string($config)
  }

  ##################################################

  if $seed_db {
    class { 'kallithea::seed_db':
      user      => $admin_user,
      pass      => $admin_pass,
      mail      => $admin_mail,
      subscribe => Class['kallithea::config'],
      before    => Class['kallithea::service'],
    }
  }

  class { '::kallithea::install': } ->
  class { '::kallithea::config': } ~>
  class { '::kallithea::service': } ->
  Class['::kallithea']

}

