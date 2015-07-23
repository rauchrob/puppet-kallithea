# Puppet-Kallithea

[![Build Status](https://travis-ci.org/rauchrob/puppet-kallithea.svg?branch=master)](https://travis-ci.org/rauchrob/puppet-kallithea)
[![Puppet Forge](http://img.shields.io/puppetforge/v/rauch/kallithea.svg)](https://forge.puppetlabs.com/rauch/kallithea)

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

This module lets you setup a [Kallithea](https://kallithea-scm.org) instance. 

## Module Description

Kallithea is *"a free software source code management system supporting two leading version control systems, Mercurial and Git."* This module allows you to install, configure and run a working Kallithea instance. It does not make any attempt to setup an Apache reverse proxy or something similar, so this is up to you.

## Setup

### What kallithea affects

* Required Packages for installing the kallithea python package (platform dependent) 
* The user under which Kallithea will run
* The Kallithea users home, containing a Python virtualenv in which Kallithea gets installed
* The Kallithea service
* Installation of git (optionally) 

### Setup Requirements

For full functionality, Kallithea requires git to be installed. This module can optionally git as well, but this requires the `puppetlabs/git` module.

### Beginning with kallithea

To get you up and running fast, simply declare

```puppet
class { 'kallithea':
  seed_db => true,
}
```

This will install Kallithea in an isolated virtualenv and create a default configuration as described in the [Kallithea setup documentation](https://pythonhosted.org/Kallithea/setup.html). As of Kallithea version 0.2.1, this default configuration will use an SQLite database backend, which is then initialized due to the `seed_db` parameter. A `kallithea` Systemd service is set up, which then gets started and enabled by default.

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

* [`kallithea::package`](#define-kallitheapackage)

#### Class `kallithea`

##### Parameters (all optional)

* `admin_mail`: Mail of the initial admin user, created during database initialization. Defaults to `root@${::fqdn}`.
* `admin_pass`: Password of the initial admin user, created during database initialization. Defaults to `adminpw`.
* `admin_user`: Name of the initial admin user, created during database initialization. Defaults to `admin`.
* `app_root`: The directory under which Kallithea will be installed (i.e. the home  directory of `$app_user`). Defaults to `/srv/kallithea`.
* `app_user`: The user under which Kallithea will be installed. Defaults to `kallithea`.
* `config`: If not `undef`, this will the content of Kallitheas main configuration file `${app_root}/kallithea.ini`. Otherwise, it will be initialized with Kallitheas defaults during installation. Defaults to `undef`
* `ldap_support`: If set to true, the python-ldap package and its dependencies will be installed into Kallitheas python environment. Defaults to `true`.
* `manage_git`: Whether to install git using the [`puppetlabs/git`](https://github.com/puppetlabs/puppetlabs-git) module. Defaults to `false`.
* `manage_python`: Whether to install Python using the [`stankevich/python`](https://github.com/stankevich/puppet-python) module. Defaults to `true`.
* `proxy`: If not `undef`, this will be the HTTP proxy settings which are used when installing Kallithea via pip. Defaults to `undef`.
* `repo_root`: The directory under which Kallithea will put the repositories. Defaults to `${app_root}/repos`.
* `seed_db`: Whether to initialize Kallitheas database during installation. A lockfile is created to prevent subsequent database resets (see documentation of the kallithea::seed_db class). Defaults to `false`.
* `service_enable`: Whether to enable the Kallithea service on boot. Defaults to `true`.
* `service_ensure`: Whether to start Kallithea as a service. Defaults to `true`.
* `version`: The version of Kallithea which should be installed. If `undef`, the latest available version will be installed. No upgrades can be performed. Defaults to `undef`.

**Note:** The values of the parameters `admin_mail`, `admin_pass` and `admin_user` are only relevant if you are using `seed_db => true`.

#### Class `kallithea::seed_db`

This class lets you initialize the database backing Kallithea. You have to do this at least once in order to use your Kallithea instance. Applying this class is idempotent, i.e. subsequent puppet runs will not reinitialize the database, as long as you don't remove the lockfile under `${app_root}/.db_initialized`.

**Attention:** Initializing Kallitheas database will wipe any previous data - use with care!

##### Parameters

* `user`: Mail of the initial admin user, created during database initialization. Defaults to `root@${::fqdn}`.
* `pass`: Password of the initial admin user, created during database initialization. Defaults to `adminpw`.
* `mail`: Name of the initial admin user, created during database initialization. Defaults to `admin`.

#### Define `kallithea::package`

This define lets you install add ons for Kallithea by installing additional Python packages into Kallitheas virtualenv.

##### Parameters 

* `title`: The name of the Python package.

## Limitations

This module has been developed been successfully tested using Kallithea v0.2.1 and v0.2.2 on the following operating systems:

* CentOS/RHEL 6 and 7
* Debian 7 and 8
* Fedora 19 and 20
* Ubuntu 12.04 and 14.04

Support for Debian 6 and 8 is planned for future releases.

## Development

See the `CONTRIBUTING.md` file, which gets distributed as part of this module archive for information on how to contribute.

