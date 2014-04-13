PolyProg Live
=============

This repository contains the configuration files for PolyProg Live. This is the
live system that we use during programming competitions. It has a number of
advantages:

- The system contains all the editors, IDEs, ... that we want
- We can make the system secure using firewalls, restricted root access, ...
- Custom commands such as `hc2-compile` can be installed on the system
- During the contest, administrators can access the machines using SSH, and
  perform remote backups and monitoring.

This repo contains the following files/folders
----------------------------------------------

.
├── 2012hc2, 2013hc2, ...
│   Various config files specific to this event. For example, SSH keys because
│   they change with each new event.
├── README.rst  -- This file
├── auto
│   ├── build
│   ├── clean
│   └── config
│   The principal debian live configuration script
├── config
│   This folder contains configuration files for debian live. Some of them are
│   generated automatically, others are written by hand. The .gitignore file should
│   exclude the automatically-generated ones.
│   ├── hooks
│   │   Scripts to perform various tasks during live system configuration, e.g.,
│   │   configuring an init script to be run during boot.
│   ├── includes.binary
│   │   Files that should go on live system binary image (e.g., boot loader
│   │   splash screen)
│   ├── includes.chroot
│   │   Files that should be present on the live system Note that some files in
│   │   here aren't version controlled because they are so large (e.g., the
│   │   Eclipse IDE).
│   ├── package-lists
        Lists of packages to be installed on the system

More information
----------------

- About debian live: http://live.debian.net/
- About the PolyProg live system: http://wiki.hc2.ch/index.php/Contestant_computer_environment
