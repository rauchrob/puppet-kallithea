#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with kallithea](#setup)
    * [What kallithea affects](#what-kallithea-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with kallithea](#beginning-with-kallithea)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

This module lets you setup a [Kallithea](https://kallithea-scm.org) instance. It has been developed for and successfully tested on RHEL7, but more platforms should follow in the future.

## Module Description

Kallithea is *"a free software source code management system supporting two leading version control systems, Mercurial and Git.* This module allows you to install, configure and run a working Kallithea instance.

## Setup

### What kallithea affects

* Required Packages for installing the kallithea python package (platform dependent) 
* The user under which Kallithea will run
* The Kallithea Users home, containing a Python virtualenv in which Kallithea gets installed
* The Kallithea Service

### Setup Requirements **OPTIONAL**

The installation of Kallithea requires `virtualenv` and `pip` to be installed.

### Beginning with kallithea

To get you up and running fast, simply declare

```puppet
class { 'kallithea':
  seed_db => true,
}
```

This will install Kallithea in an isolated virtualenv and create a default configuration as described in the [Kallithea setup documentation](https://pythonhosted.org/Kallithea/setup.html). As of Kallithea version 0.2.1, this default configuration will use an SQLite database backend, which is then initialized due to the `seed_db` parameter. A `kallithea` systemd service is set up, which then gets started and enabled by default.

If everything worked well, you should be able to browse your Kallithea instance on `http://localhost:5000`, which can be accessed using the default credentials `admin/adminpw`

## Usage

Put the classes, types, and resources for customizing, configuring, and doing the fancy stuff with your module here. 

## Reference

### Classes

#### Public Classes

* [`kallithea`](#class-kallithea)
* [`kallithea::seed_db`](#class-kallitheaseed_db)

#### Private Classes

* `kallithea::config`
* `kallithea::install`
* `kallithea::params`
* `kallithea::service`

### Defines

* [`kallithea::package`](#class-kallitheapackage)

#### Class `kallithea`

##### Parameters (all optional)

* `admin_mail`: Mail of the initial admin user, created during database initialization. Defaults to `root@${::fqdn}`.
* `admin_pass`: Password of the initial admin user, created during database initialization. Defaults to `adminpw`.
* `admin_user`: Name of the initial admin user, created during database initialization. Defaults to `admin`.
* `app_root`: The directory under which Kallithea will be installed (i.e. the home  directory of `$app_user`). Defaults to `/srv/kallithea`.
* `app_user`: The user under which Kallithea will be installed. Defaults to `kallithea`.
* `config`: If not `undef`, this will the content of Kallitheas main configuration file "${app_root}/kallithea.ini". Otherwise, it will be initialized with Kallitheas defaults during installation. Defaults to `undef`
* `ldap_support`: If set to true, the python-ldap package and its dependencies will be installed into Kallitheas python environment. Defaults to `true`.
* `manage_python`: Wheather to install Python using the [`stankevich/python`](https://github.com/stankevich/puppet-python) module. Defaults to `true`.
* `proxy`: If not `undef`, this will be the HTTP proxy settings which are used when installing Kallithea via pip. Defaults to `undef`.
* `repo_root`: The directory under which Kallithea will put the repositories. Defaults to `${app_root}/repos`.
* `seed_db`: Whether to initialize Kallitheas database during installation. A lockfile is created to prevent subsequent database resets (see documentation of the kallithea::seed_db class). Defaults to `false`.
* `service_enable`: Whether to enable the Kallithea service on boot. Defaults to `true`.
* `service_ensure`: Whether to start Kallithea as a service. Defaults to `true`.

## Limitations

This module has beed developed for and successfully tested only on RHEL7, using Kallithea v0.2.1. Consequently, currently only a systemd service definition is provided. In principle, however, it should be easy to modify the module for use with other platforms as well.

## Development

See the `CONTRIBUTING.md` file, which gets distributed as part of this module archive for information on how to contribute.

