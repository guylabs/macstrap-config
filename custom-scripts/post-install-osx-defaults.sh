#!/bin/sh
set -eo

# ~/.macos — https://mths.be/macos

# Show banner
echo
echo "#################################"
echo "# Setting Mac OS X defaults ... #"
echo "#################################"
echo

echo "\033[1mPlease select if you want to apply the custom Mac OSX configuration\033[0m:"
echo "[1] Apply the configuration"
echo "[2] Skip applying the configuration"
echo
printf "Enter your decision: "
echo

# The installation of OSX defaults can be forced. This is used in CI environments where there is no possibility to read the input.
if [ -z "$CI" ]; then
  read -r applyConfiguration
else
  applyConfiguration="1"
fi

case $applyConfiguration in
    "1")
        # Close any open System Preferences panes, to prevent them from overriding
        # settings we’re about to change
        osascript -e 'tell application "System Preferences" to quit'

        # Ask for the administrator password upfront
        echo "We need sudo right to set some Mac OS X defaults."
        sudo true

        # The installation of OSX defaults can be forced. This is used in CI environments where there is no possibility to read the input.
        if [ -z "$CI" ]; then
            # Set computer name (as done via System Preferences → Sharing)
            printf "Enter the hostname: "

            # read the hostname
            read -r hostname

            sudo scutil --set ComputerName "$hostname"
            sudo scutil --set HostName "$hostname"
            sudo scutil --set LocalHostName "$hostname"
            sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$hostname"
        fi

        ###############################################################################
        echo
        echo "\t General UI/UX"
        echo "\t #################################"
        echo
        ###############################################################################

        echo "\t- Set standby delay to 24 hours (default is 1 hour)"
        sudo pmset -a standbydelay 86400

        echo "\t- Disable the sound effects on boot"
        sudo nvram SystemAudioVolume=" "

        echo "\t- Set sidebar icon size to medium"
        defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2

        echo "\t- Always show scrollbars"
        defaults write NSGlobalDomain AppleShowScrollBars -string "Always"

        echo "\t- Disabling OS X Gate Keeper"
        echo "\t\t- (You'll be able to install any app you want from here on, not just Mac App Store apps)"
        sudo spctl --master-disable
        sudo defaults write /var/db/SystemPolicy-prefs.plist enabled -string no
        defaults write com.apple.LaunchServices LSQuarantine -bool false

        echo "\t- Expanding the save panel by default"
        defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
        defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
        defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
        defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

        echo "\t- Automatically quit printer app once the print jobs complete"
        defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

        echo "\t- Disabling resume system-wide "
        defaults write NSGlobalDomain NSQuitAlwaysKeepsWindows -bool false
        defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false

        echo "\t- Disabling automatic termination of inactive apps"
        defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true

        echo "\t- Saving to disk (not to iCloud) by default"
        defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

        echo "\t- Disabling the \"Are you sure you want to open this application?\" dialog"
        defaults write com.apple.LaunchServices LSQuarantine -bool false

        echo "\t- Check for software updates daily, not just once per week"
        defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

        echo "\t- Disable smart quotes, smart dashes, period substitution, automatic capitalization and auto correct"
        defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
        defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
        defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
        defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
        defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

        echo "\t- Set Help Viewer windows to non-floating mode"
        defaults write com.apple.helpviewer DevMode -bool true

        echo "\t- Disable Notification Center and remove the menu bar icon"
        launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist 2> /dev/null

        echo "\t- Use graphite theme and dark menu bar"
        defaults write NSGlobalDomain AppleAquaColorVariant -int 6
        defaults write NSGlobalDomain AppleHighlightColor -string "0.847059 0.847059 0.862745"
        defaults write NSGlobalDomain AppleInterfaceStyle -string Dark

        echo "\t- Disable system sound effects"
        defaults write NSGlobalDomain "com.apple.sound.uiaudio.enabled" -int 0

        ###############################################################################
        echo
        echo "\t SSD-specific tweaks"
        echo "\t #################################"
        echo
        ###############################################################################

        echo "\t- Disable hibernation (speeds up entering sleep mode)"
        sudo pmset -a hibernatemode 0

        ###############################################################################
        echo
        echo "\t Trackpad, mouse, keyboard, Bluetooth accessories, and input"
        echo "\t #################################"
        echo
        ###############################################################################

        echo "\t- Enabling full keyboard access for all controls (e.g. enable Tab in modal dialogs)"
        defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

        echo "\t- Disabling press-and-hold for keys in favor of a key repeat"
        defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

        echo "\t- Setting a fast keyboard repeat rate"
        defaults write NSGlobalDomain KeyRepeat -int 2
        defaults write NSGlobalDomain InitialKeyRepeat -int 15

        echo "\t- Setting trackpad & mouse speed to a reasonable number"
        defaults write -g com.apple.trackpad.scaling 2
        defaults write -g com.apple.mouse.scaling 2.5

        echo "\t- Turn off keyboard illumination when computer is not used for 1 minute"
        defaults write com.apple.BezelServices kDimTime -int 60

        echo "\t- Enabling tap to click for this user and for the login screen"
        defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
        defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
        defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

        echo "\t- Enable “natural” (Lion-style) scrolling"
        defaults write NSGlobalDomain com.apple.swipescrolldirection -bool true

        echo "\t- Set language and text formats"
        # Note: if you’re in the US, replace `EUR` with `USD`, `Centimeters` with
        # `Inches`, `en_GB` with `en_US`, and `true` with `false`.
        defaults write NSGlobalDomain AppleLanguages -array "en" "de"
        defaults write NSGlobalDomain AppleLocale -string "en_US@currency=CHF"
        defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"
        defaults write NSGlobalDomain AppleMetricUnits -bool true

        echo "\t- Set the timezone; see 'sudo systemsetup -listtimezones' for other values"
        sudo systemsetup -settimezone "Europe/Zurich" > /dev/null

        ###############################################################################
        echo
        echo "\t Screen"
        echo "\t #################################"
        echo
        ###############################################################################

        echo "\t- Requiring password immediately after sleep or screen saver begins"
        defaults write com.apple.screensaver askForPassword -int 1
        defaults write com.apple.screensaver askForPasswordDelay -int 0

        echo "\t- Enabling subpixel font rendering on non-Apple LCDs"
        defaults write NSGlobalDomain AppleFontSmoothing -int 1

        echo "\t- Enable HiDPI display modes (requires restart)"
        sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true

        echo "\t- Save screenshots to the desktop"
        defaults write com.apple.screencapture location -string "${HOME}/Desktop"

        echo "\t- Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)"
        defaults write com.apple.screencapture type -string "png"

        echo "\t- Disable shadow in screenshots"
        defaults write com.apple.screencapture disable-shadow -bool true

        ###############################################################################
        echo
        echo "\t Finder"
        echo "\t #################################"
        echo
        ###############################################################################

        echo "\t- Finder: allow quitting via ⌘ + Q; doing so will also hide desktop icons"
        defaults write com.apple.finder QuitMenuItem -bool true

        echo "\t- Finder: disable window animations and Get Info animations"
        defaults write com.apple.finder DisableAllAnimations -bool true

        echo "\t- Set home folder as the default location for new Finder windows"
        # For other paths, use `PfLo` and `file:///full/path/here/`
        defaults write com.apple.finder NewWindowTarget -string "PfDe"
        defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

        echo "\t- Showing all filename extensions in Finder by default"
        defaults write NSGlobalDomain AppleShowAllExtensions -bool true

        echo "\t- Showing status bar in Finder by default"
        defaults write com.apple.finder ShowStatusBar -bool true

        echo "\t- Showing path bar in Finder by default"
        defaults write com.apple.finder ShowPathbar -bool true

        echo "\t- Allowing text selection in Quick Look/Preview in Finder by default"
        defaults write com.apple.finder QLEnableTextSelection -bool true

        echo "\t- Displaying full POSIX path as Finder window title"
        defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

        echo "\t- Keep folders on top when sorting by name"
        defaults write com.apple.finder _FXSortFoldersFirst -bool true

        echo "\t- When performing a search, search the current folder by default"
        defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

        echo "\t- Enable spring loading for directories"
        defaults write NSGlobalDomain com.apple.springing.enabled -bool true

        echo "\t- Disable disk image verification"
        defaults write com.apple.frameworks.diskimages skip-verify -bool true
        defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
        defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

        echo "\t- Automatically open a new Finder window when a volume is mounted"
        defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
        defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
        defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

        echo "\t- Enable AirDrop over Ethernet and on unsupported Macs running Lion"
        defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

        echo "\t- Disabling the warning when changing a file extension"
        defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

        echo "\t- Use list view in all Finder windows by default"
        defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

        echo "\t- Avoiding the creation of .DS_Store files on network volumes"
        defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

        echo "\t- Avoiding the creation of .DS_Store files on USB volumes"
        defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

        echo "\t- Show hidden files in all Finder windows by default"
        defaults write com.apple.finder AppleShowAllFiles -bool true

        echo "\t- Show item info near icons on the desktop and in other icon views"
        /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
        /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist

        echo "\t- Expand the following File Info panes: 'General', 'Open with', and 'Sharing & Permissions'"
        defaults write com.apple.finder FXInfoPanesExpanded -dict \
        	General -bool true \
        	OpenWith -bool true \
        	Privileges -bool true

        echo "\t- Enabling snap-to-grid for icons on the desktop and in other icon views"
        /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
        /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

        echo "\t- Showing the ~/Library folder"
        chflags nohidden ~/Library

        echo "\t- Showing the /Volumes folder"
        sudo chflags nohidden /Volumes

        # Kill all finder instances to reload the new configuration
        killall Finder

        ###############################################################################
        echo
        echo "\t Dock, Dashboard, and hot corners"
        echo "\t #################################"
        echo
        ###############################################################################

        echo "\t- Enable highlight hover effect for the grid view of a stack (Dock)"
        defaults write com.apple.dock mouse-over-hilite-stack -bool true

        echo "\t- Set the icon size of Dock items to 36 pixels"
        defaults write com.apple.dock tilesize -int 36

        echo "\t- Change minimize/maximize window effect"
        defaults write com.apple.dock mineffect -string "scale"

        echo "\t- Minimize windows into their application’s icon"
        defaults write com.apple.dock minimize-to-application -bool true

        echo "\t- Enable spring loading for all Dock items"
        defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true

        echo "\t- Show indicator lights for open applications in the Dock"
        defaults write com.apple.dock show-process-indicators -bool true

        echo "\t- Wipe all (default) app icons from the Dock"
        # This is only really useful when setting up a new Mac, or if you don’t use
        # the Dock to launch apps.
        defaults write com.apple.dock persistent-apps -array

        echo "\t- Show only open applications in the Dock"
        defaults write com.apple.dock static-only -bool true

        echo "\t- Don’t animate opening applications from the Dock"
        defaults write com.apple.dock launchanim -bool false

        echo "\t- Speed up Mission Control animations"
        defaults write com.apple.dock expose-animation-duration -float 0.1

        echo "\t- Don’t group windows by application in Mission Control"
        # (i.e. use the old Exposé behavior instead)
        defaults write com.apple.dock expose-group-by-app -bool false

        echo "\t- Disable Dashboard"
        defaults write com.apple.dashboard mcx-disabled -bool true

        echo "\t- Don’t show Dashboard as a Space"
        defaults write com.apple.dock dashboard-in-overlay -bool true

        echo "\t- Don’t automatically rearrange Spaces based on most recent use"
        defaults write com.apple.dock mru-spaces -bool false

        echo "\t- Remove the auto-hiding Dock delay"
        defaults write com.apple.dock autohide-delay -float 0

        echo "\t- Remove the animation when hiding/showing the Dock"
        defaults write com.apple.dock autohide-time-modifier -float 0

        echo "\t- Automatically hide and show the Dock"
        defaults write com.apple.dock autohide -bool true

        echo "\t- Make Dock icons of hidden applications translucent"
        defaults write com.apple.dock showhidden -bool true

        echo "\t- Disable the Launchpad gesture (pinch with thumb and three fingers)"
        defaults write com.apple.dock showLaunchpadGestureEnabled -int 0

        echo "\t- Reset Launchpad, but keep the desktop wallpaper intact"
        find "${HOME}/Library/Application Support/Dock" -name "*-*.db" -maxdepth 1 -delete

        # Hot corners
        # Possible values:
        #  0: no-op
        #  2: Mission Control
        #  3: Show application windows
        #  4: Desktop
        #  5: Start screen saver
        #  6: Disable screen saver
        #  7: Dashboard
        # 10: Put display to sleep
        # 11: Launchpad
        # 12: Notification Center
        echo "\t- Hot corners: Top left screen corner → Put display to sleep"
        defaults write com.apple.dock wvous-tl-corner -int 10
        defaults write com.apple.dock wvous-tl-modifier -int 0

        ###############################################################################
        echo
        echo "\t Safari & WebKit"
        echo "\t #################################"
        echo
        ###############################################################################

        echo "\t- Privacy: don’t send search queries to Apple"
        defaults write com.apple.Safari UniversalSearchEnabled -bool false
        defaults write com.apple.Safari SuppressSearchSuggestions -bool true

        echo "\t- Press Tab to highlight each item on a web page"
        defaults write com.apple.Safari WebKitTabToLinksPreferenceKey -bool true
        defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2TabsToLinks -bool true

        echo "\t- Show the full URL in the address bar (note: this still hides the scheme)"
        defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

        echo "\t- Set Safari’s home page to `about:blank` for faster loading"
        defaults write com.apple.Safari HomePage -string "about:blank"

        echo "\t- Prevent Safari from opening ‘safe’ files automatically after downloading"
        defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

        echo "\t- Allow hitting the Backspace key to go to the previous page in history"
        defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2BackspaceKeyNavigationEnabled -bool true

        echo "\t- Hide Safari’s bookmarks bar by default"
        defaults write com.apple.Safari ShowFavoritesBar -bool false

        echo "\t- Hide Safari’s sidebar in Top Sites"
        defaults write com.apple.Safari ShowSidebarInTopSites -bool false

        echo "\t- Disable Safari’s thumbnail cache for History and Top Sites"
        defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2

        echo "\t- Enable Safari’s debug menu"
        defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

        echo "\t- Make Safari’s search banners default to Contains instead of Starts With"
        defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false

        echo "\t- Remove useless icons from Safari’s bookmarks bar"
        defaults write com.apple.Safari ProxiesInBookmarksBar "()"

        echo "\t- Enable the Develop menu and the Web Inspector in Safari"
        defaults write com.apple.Safari IncludeDevelopMenu -bool true
        defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
        defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

        echo "\t- Add a context menu item for showing the Web Inspector in web views"
        defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

        echo "\t- Enable continuous spellchecking"
        defaults write com.apple.Safari WebContinuousSpellCheckingEnabled -bool true

        echo "\t- Disable auto-correct"
        defaults write com.apple.Safari WebAutomaticSpellingCorrectionEnabled -bool false

        echo "\t- Disable AutoFill"
        defaults write com.apple.Safari AutoFillFromAddressBook -bool false
        defaults write com.apple.Safari AutoFillPasswords -bool false
        defaults write com.apple.Safari AutoFillCreditCardData -bool false
        defaults write com.apple.Safari AutoFillMiscellaneousForms -bool false

        echo "\t- Warn about fraudulent websites"
        defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool true

        echo "\t- Enable 'Do Not Track'"
        defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true

        echo "\t- Update extensions automatically"
        defaults write com.apple.Safari InstallExtensionUpdatesAutomatically -bool true

        ###############################################################################
        echo
        echo "\t Mail"
        echo "\t #################################"
        echo
        ###############################################################################

        echo "\t- Disable send and reply animations in Mail.app"
        defaults write com.apple.mail DisableReplyAnimations -bool true
        defaults write com.apple.mail DisableSendAnimations -bool true

        echo "\t- Copy email addresses as 'foo@example.com' instead of 'Foo Bar <foo@example.com>' in Mail.app"
        defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

        echo "\t- Add the keyboard shortcut ⌘ + Enter to send an email in Mail.app"
        defaults write com.apple.mail NSUserKeyEquivalents -dict-add "Send" "@\U21a9"

        echo "\t- Display emails in threaded mode, sorted by date (newest at the top)"
        defaults write com.apple.mail InboxViewerAttributes -dict-add "DisplayInThreadedMode" -string "yes"
        defaults write com.apple.mail InboxViewerAttributes -dict-add "SortedDescending" -string "no"
        defaults write com.apple.mail InboxViewerAttributes -dict-add "SortOrder" -string "received-date"

        defaults write com.apple.mail DraftsViewerAttributes -dict-add "DisplayInThreadedMode" -string "yes"
        defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortedDescending" -string "no"
        defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortOrder" -string "received-date"

        defaults write com.apple.mail ArchiveViewerAttributes -dict-add "DisplayInThreadedMode" -string "yes"
        defaults write com.apple.mail ArchiveViewerAttributes -dict-add "SortedDescending" -string "no"
        defaults write com.apple.mail ArchiveViewerAttributes -dict-add "SortOrder" -string "received-date"

        echo "\t- Display emails sorted by date (newest at the top) inside a thread"
        defaults write com.apple.mail ConversationViewSortDescending -int 1

        echo "\t- Do not play mail sounds"
        defaults write com.apple.mail PlayMailSounds -int 0
        defaults write com.apple.mail NewMessagesSoundName -string ""

        echo "\t- Disable inline attachments (just show the icons)"
        defaults write com.apple.mail DisableInlineAttachmentViewing -bool true

        echo "\t- Disable automatic spell checking"
        defaults write com.apple.mail SpellCheckingBehavior -string "NoSpellCheckingEnabled"

        ###############################################################################
        echo
        echo "\t Spotlight"
        echo "\t #################################"
        echo
        ###############################################################################

        echo "\t- Change indexing order and disable some search results"
        # Yosemite-specific search results (remove them if you are using macOS 10.9 or older):
        # 	MENU_DEFINITION
        # 	MENU_CONVERSION
        # 	MENU_EXPRESSION
        # 	MENU_SPOTLIGHT_SUGGESTIONS (send search queries to Apple)
        # 	MENU_WEBSEARCH             (send search queries to Apple)
        # 	MENU_OTHER
        defaults write com.apple.spotlight orderedItems -array \
        	'{"enabled" = 1;"name" = "APPLICATIONS";}' \
        	'{"enabled" = 1;"name" = "SYSTEM_PREFS";}' \
        	'{"enabled" = 1;"name" = "DIRECTORIES";}' \
        	'{"enabled" = 1;"name" = "PDF";}' \
        	'{"enabled" = 1;"name" = "FONTS";}' \
        	'{"enabled" = 0;"name" = "DOCUMENTS";}' \
        	'{"enabled" = 0;"name" = "MESSAGES";}' \
        	'{"enabled" = 0;"name" = "CONTACT";}' \
        	'{"enabled" = 0;"name" = "EVENT_TODO";}' \
        	'{"enabled" = 0;"name" = "IMAGES";}' \
        	'{"enabled" = 0;"name" = "BOOKMARKS";}' \
        	'{"enabled" = 0;"name" = "MUSIC";}' \
        	'{"enabled" = 0;"name" = "MOVIES";}' \
        	'{"enabled" = 0;"name" = "PRESENTATIONS";}' \
        	'{"enabled" = 0;"name" = "SPREADSHEETS";}' \
        	'{"enabled" = 0;"name" = "SOURCE";}' \
        	'{"enabled" = 0;"name" = "MENU_DEFINITION";}' \
        	'{"enabled" = 0;"name" = "MENU_OTHER";}' \
        	'{"enabled" = 0;"name" = "MENU_CONVERSION";}' \
        	'{"enabled" = 0;"name" = "MENU_EXPRESSION";}' \
        	'{"enabled" = 0;"name" = "MENU_WEBSEARCH";}' \
        	'{"enabled" = 0;"name" = "MENU_SPOTLIGHT_SUGGESTIONS";}'

        echo "\t- Load new settings before rebuilding the index"
        sudo killall mds > /dev/null 2>&1

        echo "\t- Make sure indexing is enabled for the main volume"
        sudo mdutil -i on / > /dev/null

        echo "\t- Rebuild the index from scratch"
        sudo mdutil -E / > /dev/null

        ###############################################################################
        echo
        echo "\t Terminal"
        echo "\t #################################"
        echo
        ###############################################################################

        echo "\t- Only use UTF-8 in Terminal.app"
        defaults write com.apple.terminal StringEncodings -array 4

        # Only apply a custom terminal theme if not in CI, as on CI the command times out.
        if [ -z "$CI" ]; then

            echo "\t- Use a modified version of the Afterglow theme by default in Terminal.app"
            osascript -e "
            tell application \"Terminal\"

                set themeName to \"Afterglow\"

                (* Open the custom theme so that it gets added to the list
                of available terminal themes (note: this will open two
                additional terminal windows). *)
                do shell script \"open \"$HOME/init/\" & themeName & \".terminal\"\"

                (* Wait a little bit to ensure that the custom theme is added. *)
                delay 1

                (* Set the custom theme as the default terminal theme. *)
                set default settings to settings set themeName

            end tell"

        fi

        echo "\t- Enable Secure Keyboard Entry in Terminal.app"
        # See: https://security.stackexchange.com/a/47786/8918
        defaults write com.apple.terminal SecureKeyboardEntry -bool true

        echo "\t- Disable the annoying line marks"
        defaults write com.apple.Terminal ShowLineMarks -int 0

        ###############################################################################
        echo
        echo "\t Time Machine"
        echo "\t #################################"
        echo
        ###############################################################################

        echo "\t- Prevent Time Machine from prompting to use new hard drives as backup volume"
        defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

        ###############################################################################
        echo
        echo "\t Activity Monitor"
        echo "\t #################################"
        echo
        ###############################################################################

        echo "\t- Show the main window when launching Activity Monitor"
        defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

        echo "\t- Visualize CPU usage in the Activity Monitor Dock icon"
        defaults write com.apple.ActivityMonitor IconType -int 5

        echo "\t- Show all processes in Activity Monitor"
        defaults write com.apple.ActivityMonitor ShowCategory -int 0

        echo "\t- Sort Activity Monitor results by CPU usage"
        defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
        defaults write com.apple.ActivityMonitor SortDirection -int 0

        ###############################################################################
        echo
        echo "\t Address Book, Dashboard, iCal, TextEdit, and Disk Utility"
        echo "\t #################################"
        echo
        ###############################################################################

        echo "\t- Enable the debug menu in Address Book"
        defaults write com.apple.addressbook ABShowDebugMenu -bool true

        echo "\t- Enable Dashboard dev mode (allows keeping widgets on the desktop)"
        defaults write com.apple.dashboard devmode -bool true

        echo "\t- Enable the debug menu in iCal (pre-10.8)"
        defaults write com.apple.iCal IncludeDebugMenu -bool true

        echo "\t- Use plain text mode for new TextEdit documents"
        defaults write com.apple.TextEdit RichText -int 0

        echo "\t- Open and save files as UTF-8 in TextEdit"
        defaults write com.apple.TextEdit PlainTextEncoding -int 4
        defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

        echo "\t- Enable the debug menu in Disk Utility"
        defaults write com.apple.DiskUtility DUDebugMenuEnabled -bool true
        defaults write com.apple.DiskUtility advanced-image-options -bool true

        ###############################################################################
        echo
        echo "\t Mac App Store"
        echo "\t #################################"
        echo
        ###############################################################################

        echo "\t- Enable the WebKit Developer Tools in the Mac App Store"
        defaults write com.apple.appstore WebKitDeveloperExtras -bool true

        echo "\t- Enable Debug Menu in the Mac App Store"
        defaults write com.apple.appstore ShowDebugMenu -bool true

        echo "\t- Enable the automatic update check"
        defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

        echo "\t- Check for software updates daily, not just once per week"
        defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

        echo "\t- Download newly available updates in background"
        defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1

        echo "\t- Install System data files & security updates"
        defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1

        echo "\t- Turn on app auto-update"
        defaults write com.apple.commerce AutoUpdate -bool true

        echo "\t- Allow the App Store to reboot machine on macOS updates"
        defaults write com.apple.commerce AutoUpdateRestartRequired -bool true

        ###############################################################################
        echo
        echo "\t Photos"
        echo "\t #################################"
        echo
        ###############################################################################

        echo "\t- Prevent Photos from opening automatically when devices are plugged in"
        defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

        ###############################################################################
        echo
        echo "\t Messages"
        echo "\t #################################"
        echo
        ###############################################################################

        echo "\t- Disable smart quotes as it's annoying for messages that contain code"
        defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticQuoteSubstitutionEnabled" -bool false

        # Disable continuous spell checking
        defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "continuousSpellCheckingEnabled" -bool false

        ###############################################################################
        echo
        echo "\t Google Chrome"
        echo "\t #################################"
        echo

        echo "\t- Disable the all too sensitive backswipe on trackpads"
        defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false

        echo "\t- Disable the all too sensitive backswipe on Magic Mouse"
        defaults write com.google.Chrome AppleEnableMouseSwipeNavigateWithScrolls -bool false

        echo "\t- Use the system-native print preview dialog"
        defaults write com.google.Chrome DisablePrintPreview -bool true

        echo "\t- Expand the print dialog by default"
        defaults write com.google.Chrome PMPrintingExpandedStateForPrint2 -bool true


        ###############################################################################
        echo
        echo "\t OSX defaults applied. Please do a restart after these changes."
        echo "\t #################################"
        echo
        ;;
    *)
        echo
        echo "\033[1mSkipped applying custom Mac OSX configuration\033[0m"
        ;;
esac
