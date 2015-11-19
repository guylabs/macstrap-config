# `hooks` folder
This folder is used for apps/tools specific hooks to be able to execute something before (`pre`) or after (`post`) the installation of the app/tool. The scripts are named with the following pattern: `pre|post-{APP/TOOL-NAME}.sh` where the `{APP/TOOL-NAME}` is the name which is configured in the `macstrap.cfg` in the root of the configuration folder.

Please use the following naming such that the scripts are getting executed properly:

* `pre-*.sh`: To execute the script before the installation of the defined app/tool.
* `post-*.sh`: To execute the script after the installation of the defined app/tool.
