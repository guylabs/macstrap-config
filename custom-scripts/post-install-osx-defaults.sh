#!/bin/sh
set -e

# ~/.macos — https://mths.be/macos

# Show banner
echo
echo "#################################"
echo "# Setting Mac OS X defaults ... #"
echo "#################################"
echo

printf "\033[1mPlease select if you want to apply the custom Mac OSX configuration\033[0m:\n"
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
        printf "\t General UI/UX\n"
        printf "\t #################################\n"
        echo
        ###############################################################################

        printf "\t- Set standby delay to 24 hours (default is 1 hour)\n"
        sudo pmset -a standbydelay 86400

        printf "\t- Disable the sound effects on boot\n"
        sudo nvram SystemAudioVolume=" "

        printf "\t- Set sidebar icon size to medium\n"
        defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2

        printf "\t- Always show scrollbars\n"
        defaults write NSGlobalDomain AppleShowScrollBars -string "Always\n"

        printf "\t- Disabling OS X Gate Keeper\n"
        printf "\t\t- (You'll be able to install any app you want from here on, not just Mac App Store apps)\n"
        sudo spctl --master-disable
        sudo defaults write /var/db/SystemPolicy-prefs.plist enabled -string no
        defaults write com.apple.LaunchServices LSQuarantine -bool false

        printf "\t- Expanding the save panel by default\n"
        defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
        defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
        defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
        defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

        printf "\t- Automatically quit printer app once the print jobs complete\n"
        defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

        printf "\t- Disabling resume system-wide\n"
        defaults write NSGlobalDomain NSQuitAlwaysKeepsWindows -bool false
        defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false

        printf "\t- Disabling automatic termination of inactive apps\n"
        defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true

        printf "\t- Saving to disk (not to iCloud) by default\n"
        defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

        printf "\t- Disabling the \"Are you sure you want to open this application?\" dialog\n"
        defaults write com.apple.LaunchServices LSQuarantine -bool false

        printf "\t- Check for software updates daily, not just once per week\n"
        defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

        printf "\t- Disable smart quotes, smart dashes, period substitution, automatic capitalization and auto correct\n"
        defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
        defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
        defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
        defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
        defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

        printf "\t- Set Help Viewer windows to non-floating mode\n"
        defaults write com.apple.helpviewer DevMode -bool true

        printf "\t- Disable Notification Center and remove the menu bar icon\n"
        launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist 2> /dev/null

        printf "\t- Use graphite theme and dark menu bar\n"
        defaults write NSGlobalDomain AppleAquaColorVariant -int 6
        defaults write NSGlobalDomain AppleHighlightColor -string "0.847059 0.847059 0.862745"
        defaults write NSGlobalDomain AppleInterfaceStyle -string Dark

        printf "\t- Disable system sound effects\n"
        defaults write NSGlobalDomain "com.apple.sound.uiaudio.enabled" -int 0

        printf "\t- Change date format to 24h format\n"
        defaults write com.apple.menuextra.clock DateFormat -string "d MMM HH:mm:ss"
        defaults write -globalDomain AppleICUForce24HourTime -int 1

        printf "\t- Show battery percentage in menu bar\n"
        defaults write com.apple.menuextra.battery ShowPercent -bool true

        printf "\t- Show Bluetooth icon in menu bar\n"
        defaults write com.apple.systemuiserver menuExtras -array \
            "/System/Library/CoreServices/Menu Extras/Clock.menu" \
            "/System/Library/CoreServices/Menu Extras/Battery.menu" \
            "/System/Library/CoreServices/Menu Extras/AirPort.menu" \
            "/System/Library/CoreServices/Menu Extras/VPN.menu" \
            "/System/Library/CoreServices/Menu Extras/TimeMachine.menu" \
            "/System/Library/CoreServices/Menu Extras/Displays.menu" \
            "/System/Library/CoreServices/Menu Extras/Bluetooth.menu"

        # Reload the menu bar to apply the changes
        killall SystemUIServer

        ###############################################################################
        echo
        printf "\t SSD-specific tweaks\n"
        printf "\t #################################\n"
        echo
        ###############################################################################

        printf "\t- Disable hibernation (speeds up entering sleep mode)\n"
        sudo pmset -a hibernatemode 0

        ###############################################################################
        echo
        printf "\t Trackpad, mouse, keyboard, Bluetooth accessories, and input\n"
        printf "\t #################################\n"
        echo
        ###############################################################################

        printf "\t- Enabling full keyboard access for all controls (e.g. enable Tab in modal dialogs)\n"
        defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

        printf "\t- Disabling press-and-hold for keys in favor of a key repeat\n"
        defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

        printf "\t- Setting a fast keyboard repeat rate\n"
        defaults write NSGlobalDomain KeyRepeat -int 2
        defaults write NSGlobalDomain InitialKeyRepeat -int 15

        printf "\t- Setting trackpad & mouse speed to a reasonable number\n"
        defaults write -g com.apple.trackpad.scaling 2
        defaults write -g com.apple.mouse.scaling 2.5

        printf "\t- Turn off keyboard illumination when computer is not used for 1 minute\n"
        defaults write com.apple.BezelServices kDimTime -int 60

        printf "\t- Use F1, F2, etc. as standard function keys\n"
        defaults write NSGlobalDomain "com.apple.keyboard.fnState" -int 1

        printf "\t- Enabling tap to click for this user and for the login screen\n"
        defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
        defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
        defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

        printf "\t- Enable 'natural' (Lion-style) scrolling\n"
        defaults write NSGlobalDomain com.apple.swipescrolldirection -bool true

        printf "\t- Set language and text formats\n"
        # Note: if you’re in the US, replace `EUR` with `USD`, `Centimeters` with
        # `Inches`, `en_GB` with `en_US`, and `true` with `false`.
        defaults write NSGlobalDomain AppleLanguages -array "en" "de"
        defaults write NSGlobalDomain AppleLocale -string "en_US@currency=CHF"
        defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"
        defaults write NSGlobalDomain AppleMetricUnits -bool true

        printf "\t- Set the timezone; see 'sudo systemsetup -listtimezones' for other values\n"
        sudo systemsetup -settimezone "Europe/Zurich" > /dev/null

        ###############################################################################
        echo
        printf "\t Screen\n"
        printf "\t #################################\n"
        echo
        ###############################################################################

        printf "\t- Requiring password immediately after sleep or screen saver begins\n"
        defaults write com.apple.screensaver askForPassword -int 1
        defaults write com.apple.screensaver askForPasswordDelay -int 0

        printf "\t- Enabling subpixel font rendering on non-Apple LCDs\n"
        defaults write NSGlobalDomain AppleFontSmoothing -int 1

        printf "\t- Enable HiDPI display modes (requires restart)\n"
        sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true

        printf "\t- Save screenshots to the desktop\n"
        defaults write com.apple.screencapture location -string "${HOME}/Desktop"

        printf "\t- Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)\n"
        defaults write com.apple.screencapture type -string "png"

        printf "\t- Disable shadow in screenshots\n"
        defaults write com.apple.screencapture disable-shadow -bool true

        ###############################################################################
        echo
        printf "\t Finder\n"
        printf "\t #################################\n"
        echo
        ###############################################################################

        printf "\t- Finder: allow quitting via ⌘ + Q; doing so will also hide desktop icons\n"
        defaults write com.apple.finder QuitMenuItem -bool true

        printf "\t- Finder: disable window animations and Get Info animations\n"
        defaults write com.apple.finder DisableAllAnimations -bool true

        printf "\t- Set home folder as the default location for new Finder windows\n"
        # For other paths, use `PfLo` and `file:///full/path/here/`
        defaults write com.apple.finder NewWindowTarget -string "PfDe"
        defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

        printf "\t- Showing all filename extensions in Finder by default\n"
        defaults write NSGlobalDomain AppleShowAllExtensions -bool true

        printf "\t- Showing status bar in Finder by default\n"
        defaults write com.apple.finder ShowStatusBar -bool true

        printf "\t- Showing path bar in Finder by default\n"
        defaults write com.apple.finder ShowPathbar -bool true

        printf "\t- Allowing text selection in Quick Look/Preview in Finder by default\n"
        defaults write com.apple.finder QLEnableTextSelection -bool true

        printf "\t- Displaying full POSIX path as Finder window title\n"
        defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

        printf "\t- Keep folders on top when sorting by name\n"
        defaults write com.apple.finder _FXSortFoldersFirst -bool true

        printf "\t- When performing a search, search the current folder by default\n"
        defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

        printf "\t- Enable spring loading for directories\n"
        defaults write NSGlobalDomain com.apple.springing.enabled -bool true

        printf "\t- Disable disk image verification\n"
        defaults write com.apple.frameworks.diskimages skip-verify -bool true
        defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
        defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

        printf "\t- Automatically open a new Finder window when a volume is mounted\n"
        defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
        defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
        defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

        printf "\t- Enable AirDrop over Ethernet and on unsupported Macs running Lion\n"
        defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

        printf "\t- Disabling the warning when changing a file extension\n"
        defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

        printf "\t- Use list view in all Finder windows by default\n"
        defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

        printf "\t- Avoiding the creation of .DS_Store files on network volumes\n"
        defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

        printf "\t- Avoiding the creation of .DS_Store files on USB volumes\n"
        defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

        printf "\t- Show hidden files in all Finder windows by default\n"
        defaults write com.apple.finder AppleShowAllFiles -bool true

        printf "\t- Show item info near icons on the desktop and in other icon views\n"
        /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
        /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist

        printf "\t- Expand the following File Info panes: 'General', 'Open with', and 'Sharing & Permissions'\n"
        defaults write com.apple.finder FXInfoPanesExpanded -dict \
        	General -bool true \
        	OpenWith -bool true \
        	Privileges -bool true

        printf "\t- Enabling snap-to-grid for icons on the desktop and in other icon views\n"
        /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
        /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

        printf "\t- Showing the ~/Library folder\n"
        chflags nohidden ~/Library

        printf "\t- Showing the /Volumes folder\n"
        sudo chflags nohidden /Volumes

        # Kill all finder instances to reload the new configuration
        killall Finder

        ###############################################################################
        echo
        printf "\t Dock, Dashboard, and hot corners\n"
        printf "\t #################################\n"
        echo
        ###############################################################################

        printf "\t- Enable highlight hover effect for the grid view of a stack (Dock)\n"
        defaults write com.apple.dock mouse-over-hilite-stack -bool true

        printf "\t- Set the icon size of Dock items to 36 pixels\n"
        defaults write com.apple.dock tilesize -int 36

        printf "\t- Change minimize/maximize window effect\n"
        defaults write com.apple.dock mineffect -string "scale"

        printf "\t- Minimize windows into their application’s icon\n"
        defaults write com.apple.dock minimize-to-application -bool true

        printf "\t- Enable spring loading for all Dock items\n"
        defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true

        printf "\t- Show indicator lights for open applications in the Dock\n"
        defaults write com.apple.dock show-process-indicators -bool true

        printf "\t- Wipe all (default) app icons from the Dock\n"
        # This is only really useful when setting up a new Mac, or if you don’t use
        # the Dock to launch apps.
        defaults write com.apple.dock persistent-apps -array

        printf "\t- Show only open applications in the Dock\n"
        defaults write com.apple.dock static-only -bool true

        printf "\t- Don’t animate opening applications from the Dock\n"
        defaults write com.apple.dock launchanim -bool false

        printf "\t- Speed up Mission Control animations\n"
        defaults write com.apple.dock expose-animation-duration -float 0.1

        printf "\t- Don’t group windows by application in Mission Control\n"
        # (i.e. use the old Exposé behavior instead)
        defaults write com.apple.dock expose-group-by-app -bool false

        printf "\t- Disable Dashboard\n"
        defaults write com.apple.dashboard mcx-disabled -bool true

        printf "\t- Don’t show Dashboard as a Space\n"
        defaults write com.apple.dock dashboard-in-overlay -bool true

        printf "\t- Don’t automatically rearrange Spaces based on most recent use\n"
        defaults write com.apple.dock mru-spaces -bool false

        printf "\t- Remove the auto-hiding Dock delay\n"
        defaults write com.apple.dock autohide-delay -float 0

        printf "\t- Remove the animation when hiding/showing the Dock\n"
        defaults write com.apple.dock autohide-time-modifier -float 0

        printf "\t- Automatically hide and show the Dock\n"
        defaults write com.apple.dock autohide -bool true

        printf "\t- Make Dock icons of hidden applications translucent\n"
        defaults write com.apple.dock showhidden -bool true

        printf "\t- Disable the Launchpad gesture (pinch with thumb and three fingers)\n"
        defaults write com.apple.dock showLaunchpadGestureEnabled -int 0

        printf "\t- Reset Launchpad, but keep the desktop wallpaper intact\n"
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
        printf "\t- Hot corners: Top left screen corner → Put display to sleep\n"
        defaults write com.apple.dock wvous-tl-corner -int 10
        defaults write com.apple.dock wvous-tl-modifier -int 0

        ###############################################################################
        echo
        printf "\t Safari & WebKit\n"
        printf "\t #################################\n"
        echo
        ###############################################################################

        printf "\t- Privacy: don’t send search queries to Apple\n"
        defaults write com.apple.Safari UniversalSearchEnabled -bool false
        defaults write com.apple.Safari SuppressSearchSuggestions -bool true

        printf "\t- Press Tab to highlight each item on a web page\n"
        defaults write com.apple.Safari WebKitTabToLinksPreferenceKey -bool true
        defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2TabsToLinks -bool true

        printf "\t- Show the full URL in the address bar (note: this still hides the scheme)\n"
        defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

        printf "\t- Set Safari’s home page to 'about:blank' for faster loading\n"
        defaults write com.apple.Safari HomePage -string "about:blank"

        printf "\t- Prevent Safari from opening ‘safe’ files automatically after downloading\n"
        defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

        printf "\t- Allow hitting the Backspace key to go to the previous page in history\n"
        defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2BackspaceKeyNavigationEnabled -bool true

        printf "\t- Hide Safari’s bookmarks bar by default\n"
        defaults write com.apple.Safari ShowFavoritesBar -bool false

        printf "\t- Hide Safari’s sidebar in Top Sites\n"
        defaults write com.apple.Safari ShowSidebarInTopSites -bool false

        printf "\t- Disable Safari’s thumbnail cache for History and Top Sites\n"
        defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2

        printf "\t- Enable Safari’s debug menu\n"
        defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

        printf "\t- Make Safari’s search banners default to Contains instead of Starts With\n"
        defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false

        printf "\t- Remove useless icons from Safari’s bookmarks bar\n"
        defaults write com.apple.Safari ProxiesInBookmarksBar "()"

        printf "\t- Enable the Develop menu and the Web Inspector in Safari\n"
        defaults write com.apple.Safari IncludeDevelopMenu -bool true
        defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
        defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

        printf "\t- Add a context menu item for showing the Web Inspector in web views\n"
        defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

        printf "\t- Enable continuous spellchecking\n"
        defaults write com.apple.Safari WebContinuousSpellCheckingEnabled -bool true

        printf "\t- Disable auto-correct\n"
        defaults write com.apple.Safari WebAutomaticSpellingCorrectionEnabled -bool false

        printf "\t- Disable AutoFill\n"
        defaults write com.apple.Safari AutoFillFromAddressBook -bool false
        defaults write com.apple.Safari AutoFillPasswords -bool false
        defaults write com.apple.Safari AutoFillCreditCardData -bool false
        defaults write com.apple.Safari AutoFillMiscellaneousForms -bool false

        printf "\t- Warn about fraudulent websites\n"
        defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool true

        printf "\t- Enable 'Do Not Track'\n"
        defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true

        printf "\t- Update extensions automatically\n"
        defaults write com.apple.Safari InstallExtensionUpdatesAutomatically -bool true

        ###############################################################################
        echo
        printf "\t Mail\n"
        printf "\t #################################\n"
        echo
        ###############################################################################

        printf "\t- Disable send and reply animations in Mail.app\n"
        defaults write com.apple.mail DisableReplyAnimations -bool true
        defaults write com.apple.mail DisableSendAnimations -bool true

        printf "\t- Copy email addresses as 'foo@example.com' instead of 'Foo Bar <foo@example.com>' in Mail.app\n"
        defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

        printf "\t- Add the keyboard shortcut ⌘ + Enter to send an email in Mail.app\n"
        defaults write com.apple.mail NSUserKeyEquivalents -dict-add "Send" "@\U21a9"

        printf "\t- Display emails in threaded mode, sorted by date (newest at the top)\n"
        defaults write com.apple.mail InboxViewerAttributes -dict-add "DisplayInThreadedMode" -string "yes"
        defaults write com.apple.mail InboxViewerAttributes -dict-add "SortedDescending" -string "no"
        defaults write com.apple.mail InboxViewerAttributes -dict-add "SortOrder" -string "received-date"

        defaults write com.apple.mail DraftsViewerAttributes -dict-add "DisplayInThreadedMode" -string "yes"
        defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortedDescending" -string "no"
        defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortOrder" -string "received-date"

        defaults write com.apple.mail ArchiveViewerAttributes -dict-add "DisplayInThreadedMode" -string "yes"
        defaults write com.apple.mail ArchiveViewerAttributes -dict-add "SortedDescending" -string "no"
        defaults write com.apple.mail ArchiveViewerAttributes -dict-add "SortOrder" -string "received-date"

        printf "\t- Display emails sorted by date (newest at the top) inside a thread\n"
        defaults write com.apple.mail ConversationViewSortDescending -int 1

        printf "\t- Do not play mail sounds\n"
        defaults write com.apple.mail PlayMailSounds -int 0
        defaults write com.apple.mail NewMessagesSoundName -string ""

        printf "\t- Add invitations to Calendar automatically\n"
        defaults write com.apple.mail CalendarInviteRuleEnabled -int 1

        printf "\t- Automatically try sending later if outgoing server is unavailable\n"
        defaults write com.apple.mail SuppressDeliveryFailure -int 1
        
        printf "\t- Check for new emails automatically\n"
        defaults write com.apple.mail PollTime -int -1
        
        ###############################################################################
        echo
        printf "\t Calendar\n"
        printf "\t #################################\n"
        echo
        ###############################################################################

        printf "\t- Show week numbers\n"
        defaults write com.apple.mail  "Show Week Numbers" -int 1
        
        printf "\t- Set Monday as first day of week\n"
        defaults write com.apple.mail  "first day of week -int 1
       
        ###############################################################################
        echo
        printf "\t Spotlight\n"
        printf "\t #################################\n"
        echo
        ###############################################################################

        printf "\t- Change indexing order and disable some search results\n"
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

        printf "\t- Load new settings before rebuilding the index\n"
        sudo killall mds > /dev/null 2>&1

        printf "\t- Make sure indexing is enabled for the main volume\n"
        sudo mdutil -i on / > /dev/null

        printf "\t- Rebuild the index from scratch\n"
        sudo mdutil -E / > /dev/null

        ###############################################################################
        echo
        printf "\t Terminal\n"
        printf "\t #################################\n"
        echo
        ###############################################################################

        printf "\t- Only use UTF-8 in Terminal.app\n"
        defaults write com.apple.terminal StringEncodings -array 4

        # Only apply a custom terminal theme if not in CI, as on CI the command times out.
        if [ -z "$CI" ]; then

            printf "\t- Use a modified version of the Afterglow theme by default in Terminal.app\n"
            osascript -e '
            tell application "Terminal"

                (* Open the custom theme so that it gets added to the list
                of available terminal themes (note: this will open two
                additional terminal windows). *)
                do shell script "open $HOME/init/Afterglow.terminal"

                (* Wait a little bit to ensure that the custom theme is added. *)
                delay 1

                (* Set the custom theme as the default terminal theme. *)
                set default settings to settings set "Afterglow"

            end tell'

        fi

        printf "\t- Enable Secure Keyboard Entry in Terminal.app\n"
        # See: https://security.stackexchange.com/a/47786/8918
        defaults write com.apple.terminal SecureKeyboardEntry -bool true

        printf "\t- Disable the annoying line marks\n"
        defaults write com.apple.Terminal ShowLineMarks -int 0

        ###############################################################################
        echo
        printf "\t Time Machine\n"
        printf "\t #################################\n"
        echo
        ###############################################################################

        printf "\t- Prevent Time Machine from prompting to use new hard drives as backup volume\n"
        defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

        ###############################################################################
        echo
        printf "\t Activity Monitor\n"
        printf "\t #################################\n"
        echo
        ###############################################################################

        printf "\t- Show the main window when launching Activity Monitor\n"
        defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

        printf "\t- Visualize CPU usage in the Activity Monitor Dock icon\n"
        defaults write com.apple.ActivityMonitor IconType -int 5

        printf "\t- Show all processes in Activity Monitor\n"
        defaults write com.apple.ActivityMonitor ShowCategory -int 0

        printf "\t- Sort Activity Monitor results by CPU usage\n"
        defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
        defaults write com.apple.ActivityMonitor SortDirection -int 0

        ###############################################################################
        echo
        printf "\t Address Book, Dashboard, iCal, TextEdit, and Disk Utility\n"
        printf "\t #################################\n"
        echo
        ###############################################################################

        printf "\t- Enable the debug menu in Address Book\n"
        defaults write com.apple.addressbook ABShowDebugMenu -bool true

        printf "\t- Enable Dashboard dev mode (allows keeping widgets on the desktop)\n"
        defaults write com.apple.dashboard devmode -bool true

        printf "\t- Enable the debug menu in iCal (pre-10.8)\n"
        defaults write com.apple.iCal IncludeDebugMenu -bool true

        printf "\t- Use plain text mode for new TextEdit documents\n"
        defaults write com.apple.TextEdit RichText -int 0

        printf "\t- Open and save files as UTF-8 in TextEdit\n"
        defaults write com.apple.TextEdit PlainTextEncoding -int 4
        defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

        printf "\t- Enable the debug menu in Disk Utility\n"
        defaults write com.apple.DiskUtility DUDebugMenuEnabled -bool true
        defaults write com.apple.DiskUtility advanced-image-options -bool true

        ###############################################################################
        echo
        printf "\t Mac App Store\n"
        printf "\t #################################\n"
        echo
        ###############################################################################

        printf "\t- Enable the WebKit Developer Tools in the Mac App Store\n"
        defaults write com.apple.appstore WebKitDeveloperExtras -bool true

        printf "\t- Enable Debug Menu in the Mac App Store\n"
        defaults write com.apple.appstore ShowDebugMenu -bool true

        printf "\t- Enable the automatic update check\n"
        defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

        printf "\t- Check for software updates daily, not just once per week\n"
        defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

        printf "\t- Download newly available updates in background\n"
        defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1

        printf "\t- Install System data files & security updates\n"
        defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1

        printf "\t- Turn on app auto-update\n"
        defaults write com.apple.commerce AutoUpdate -bool true

        printf "\t- Allow the App Store to reboot machine on macOS updates\n"
        defaults write com.apple.commerce AutoUpdateRestartRequired -bool true

        ###############################################################################
        echo
        printf "\t Photos\n"
        printf "\t #################################\n"
        echo
        ###############################################################################

        printf "\t- Prevent Photos from opening automatically when devices are plugged in\n"
        defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

        ###############################################################################
        echo
        printf "\t Messages\n"
        printf "\t #################################\n"
        echo
        ###############################################################################

        printf "\t- Disable smart quotes as it's annoying for messages that contain code\n"
        defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticQuoteSubstitutionEnabled" -bool false

        # Disable continuous spell checking
        defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "continuousSpellCheckingEnabled" -bool false

        ###############################################################################
        echo
        printf "\t Google Chrome\n"
        printf "\t #################################\n"
        echo

        printf "\t- Disable the all too sensitive backswipe on trackpads\n"
        defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false

        printf "\t- Disable the all too sensitive backswipe on Magic Mouse\n"
        defaults write com.google.Chrome AppleEnableMouseSwipeNavigateWithScrolls -bool false

        printf "\t- Use the system-native print preview dialog\n"
        defaults write com.google.Chrome DisablePrintPreview -bool true

        printf "\t- Expand the print dialog by default\n"
        defaults write com.google.Chrome PMPrintingExpandedStateForPrint2 -bool true


        ###############################################################################
        echo
        printf "\t OSX defaults applied. Please do a restart after these changes.\n"
        printf "\t #################################\n"
        echo
        ;;
    *)
        echo
        printf "\033[1mSkipped applying custom Mac OSX configuration\033[0m\n"
        ;;
esac
