# `custom-scripts` folder
This folder is used for custom scripts which are executed by macstrap after all other packages are installed.
The scripts need to be named in the following pattern:

* `boot-*.sh`: These scripts will be executed after the `boot` command of macstrap.
* `update-*.sh`: These scripts will be executed after the `update` command of macstrap.
* `backup-*.sh`: These scripts will be executed after the `backup` command of macstrap.
* `restore-*.sh`: These scripts will be executed after the `restore` command of macstrap.
