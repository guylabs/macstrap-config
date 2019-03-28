[![Build Status](https://travis-ci.org/guylabs/macstrap.svg?branch=master)](https://travis-ci.org/guylabs/macstrap)

# macstrap-config
Default configuration repository for [macstrap](https://github.com/guylabs/macstrap). Please check the individual `README.md` in each folder to get more information about the structure of the macstrap configuration.

## Where to search for command line tools

You can find all command line tools on the [Brew Formulae](https://formulae.brew.sh/formula/) page. Just copy the name of the formula and paste it into the `binaries` array in the `macstrap.cfg` file.

## Where to search for GUI applications

You can find all GUI applications on the [Brew Cask Github Repository](https://github.com/Homebrew/homebrew-cask/tree/master/Casks). Just copy the filename of the cask and paste it into the `apps` array in the `macstrap.cfg` file.

## Where to search for App Store applications

To get the App Store application `id` used to install the application you can open the App Store, search the application and there click on copy link and you will receive a link similar to `https://itunes.apple.com/ch/app/affinity-photo/id824183456?l=en&mt=12`.
From this link you can extract the `id` which is the number after the `id` string until the `?`. Next add the copied `id` to the `appStoreApps` array in the `macstrap.cfg` file.

# License

macstrap is available under the [MIT license](https://github.com/guylabs/macstrap/blob/master/LICENSE).

(c) Guy Brand
(c) Ethan Schoonover - Solarized iTerm2 theme (https://github.com/altercation/solarized)
