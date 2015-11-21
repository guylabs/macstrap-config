# `commands` folder
This folder is used for the default command scripts of macstrap. The following scripts are **needed** such that macstrap is fully functional:

* `install.sh`: The main install script which is called when executing the `macstrap install` command.
* `update.sh`: The main update script which is called when executing the `macstrap update` command.
* `backup.sh`: The main backup script which is called when executing the `macstrap backup` command.
* `restore.sh`: The main restore script which is called when executing the `macstrap restore` command.

In all these scripts you have the following variables available:

* `$macstrapVersion`: The version of macstrap.
* `$macstrapConfigFolder`: The configuration folder of macstrap which is by default `~/.macstrap`.
* `$macstrapConfigFile`: The configuration file of macstrap which is by default `~/.macstrap/macstrap.cfg`.