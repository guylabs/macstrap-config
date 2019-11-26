# `custom-scripts` folder
This folder is used for custom scripts which are executed by macstrap before or after the internal commands.
The scripts need to be named in the following pattern:

* `pre-install-*.sh`: These scripts will be executed before the `macstrap install` command.
* `post-install-*.sh`: These scripts will be executed after the `macstrap install` command.
* `pre-update-*.sh`: These scripts will be executed before the `macstrap update` command.
* `post-update-*.sh`: These scripts will be executed after the `macstrap update` command.
