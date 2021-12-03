#!/bin/sh
 set -e

 mkdir -p "$HOME/Library/Preferences"
 symlinkFile "$macstrapConfigFolder/configs/rectangle/com.knollsoft.Rectangle.plist" "$HOME/Library/Preferences/com.knollsoft.Rectangle.plist"
 