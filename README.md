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
* A Kallithea User under which Kallithea will run
* The Kallithea Users home, containing a Python virtualenv in which Kallithea gets installed
* The Kallithea Service

### Setup Requirements **OPTIONAL**

The installation of Kallithea requires `virtualenv` and `pip` to be installed.

### Beginning with kallithea

To get you up and running fast, simply declare

```
class { 'kallithea':
  seed_db => true,
}
```

This will install Kallithea in an isolated virtualenv and create a default configuration as described in the [Kallithea setup documentation](https://pythonhosted.org/Kallithea/setup.html). As of Kallithea version 0.2.1, this default configuration will use an SQLite database backend, which is then initialized due to the `seed_db` parameter. A `kallithea` systemd service is set up, which then gets started and enabled by default.

If everything worked well, you should be able to browse your Kallithea instance on `http://localhost:5000`, which can be accessed using the default credentials `admin/adminpw`

## Usage

Put the classes, types, and resources for customizing, configuring, and doing the fancy stuff with your module here. 

## Reference

Here, list the classes, types, providers, facts, etc contained in your module. This section should include all of the under-the-hood workings of your module so people know what the module is touching on their system but don't need to mess with things. (We are working on automating this section!)

## Limitations

This module has beed developed for and successfully tested only on RHEL7, using with Kallithea v0.2.1. As such, currently only a systemd service definition is provided. In principle, however, it should be easy to modify the module for use with other platforms as well.

## Development

See the `CONTRIBUTING.md` file, which gets distributed as part of this module archive for information on how to contribute.

