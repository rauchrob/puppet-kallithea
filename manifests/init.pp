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

class kallithea (
  $admin_mail = $params::admin_mail,
  $admin_pass = $params::admin_pass,
  $admin_user = $params::admin_user,
  $app_root = $params::app_root,
  $app_user = $params::app_user,
  $config = $params::config,
  $ldap_support = $params::ldap_support,
  $manage_python = $params::manage_python,
  $repo_root = $params::repo_root,
  $seed_db = $params::seed_db,
  $service_enable = $params::service_enable,
  $service_ensure = $params::service_ensure,
) inherits ::kallithea::params {

  ##################################################
  # Data Validation

  validate_string(
    $app_user,
    $admin_user,
    $admin_pass,
    $admin_mail,
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

