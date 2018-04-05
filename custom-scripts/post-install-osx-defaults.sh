#!/usr/bin/env bash
set -e

# ~/.macos — https://mths.be/macos

# Show banner
echo
echo -e "#################################"
echo -e "# Setting Mac OS X defaults ... #"
echo -e "#################################"
echo

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront
echo -e "We need sudo right to set some Mac OS X defaults."
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###############################################################################
echo
echo -e "\t General UI/UX"
echo -e "\t #################################"
echo
###############################################################################

# Set computer name (as done via System Preferences → Sharing)
echo -n "Enter the hostname: "
echo

# read the hostname
read -e hostname

sudo scutil --set ComputerName $hostname
sudo scutil --set HostName $hostname
sudo scutil --set LocalHostName $hostname
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string $hostname

echo -e "\t- Set standby delay to 24 hours (default is 1 hour)"
sudo pmset -a standbydelay 86400

echo -e "\t- Disable the sound effects on boot"
sudo nvram SystemAudioVolume=" "

echo -e "\t- Set sidebar icon size to medium"
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2

echo -e "\t- Always show scrollbars"
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"

echo -e "\t- Disabling OS X Gate Keeper"
echo -e "\t\t- (You'll be able to install any app you want from here on, not just Mac App Store apps)"
sudo spctl --master-disable
sudo defaults write /var/db/SystemPolicy-prefs.plist enabled -string no
defaults write com.apple.LaunchServices LSQuarantine -bool false

echo -e "\t- Expanding the save panel by default"
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

echo -e "\t- Automatically quit printer app once the print jobs complete"
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

echo -e "\t- Disabling resume system-wide "
defaults write NSGlobalDomain NSQuitAlwaysKeepsWindows -bool false
defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false

echo -e "\t- Disabling automatic termination of inactive apps"
defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true

echo -e "\t- Saving to disk (not to iCloud) by default"
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

echo -e "\t- Disabling the \"Are you sure you want to open this application?\" dialog"
defaults write com.apple.LaunchServices LSQuarantine -bool false

echo -e "\t- Check for software updates daily, not just once per week"
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

echo -e "\t- Disable smart quotes, smart dashes, period substitution, automatic capitalization and auto correct"
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

echo -e "\t- Set Help Viewer windows to non-floating mode"
defaults write com.apple.helpviewer DevMode -bool true

echo -e "\t- Disable Notification Center and remove the menu bar icon"
launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist 2> /dev/null

echo -e "\t- Use graphite theme and dark menu bar"
defaults write NSGlobalDomain AppleAquaColorVariant -int 6
defaults write NSGlobalDomain AppleHighlightColor -string "0.847059 0.847059 0.862745"
defaults write NSGlobalDomain AppleInterfaceStyle -string Dark

echo -e "\t- Disable system sound effects"
defaults write NSGlobalDomain "com.apple.sound.uiaudio.enabled" -int 0

###############################################################################
echo
echo -e "\t SSD-specific tweaks"
echo -e "\t #################################"
echo
###############################################################################

echo -e "\t- Disable hibernation (speeds up entering sleep mode)"
sudo pmset -a hibernatemode 0

###############################################################################
echo
echo -e "\t Trackpad, mouse, keyboard, Bluetooth accessories, and input"
echo -e "\t #################################"
echo
###############################################################################

echo -e "\t- Enabling full keyboard access for all controls (e.g. enable Tab in modal dialogs)"
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

echo -e "\t- Disabling press-and-hold for keys in favor of a key repeat"
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

echo -e "\t- Setting a fast keyboard repeat rate"
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

echo -e "\t- Setting trackpad & mouse speed to a reasonable number"
defaults write -g com.apple.trackpad.scaling 2
defaults write -g com.apple.mouse.scaling 2.5

echo -e "\t- Turn off keyboard illumination when computer is not used for 1 minute"
defaults write com.apple.BezelServices kDimTime -int 60

echo -e "\t- Enabling tap to click for this user and for the login screen"
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

echo -e "\t- Enable “natural” (Lion-style) scrolling"
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool true

echo -e "\t- Use scroll gesture with the Ctrl (^) modifier key to zoom"
defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144
# Follow the keyboard focus while zoomed in
defaults write com.apple.universalaccess closeViewZoomFollowsFocus -bool true

echo -e "\t- Set language and text formats"
# Note: if you’re in the US, replace `EUR` with `USD`, `Centimeters` with
# `Inches`, `en_GB` with `en_US`, and `true` with `false`.
defaults write NSGlobalDomain AppleLanguages -array "en" "de"
defaults write NSGlobalDomain AppleLocale -string "en_US@currency=CHF"
defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"
defaults write NSGlobalDomain AppleMetricUnits -bool true

echo -e "\t- Set the timezone; see 'sudo systemsetup -listtimezones' for other values"
sudo systemsetup -settimezone "Europe/Zurich" > /dev/null

###############################################################################
echo
echo -e "\t Screen"
echo -e "\t #################################"
echo
###############################################################################

echo -e "\t- Requiring password immediately after sleep or screen saver begins"
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

echo -e "\t- Enabling subpixel font rendering on non-Apple LCDs"
defaults write NSGlobalDomain AppleFontSmoothing -int 1

echo -e "\t- Enable HiDPI display modes (requires restart)"
sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true

echo -e "\t- Save screenshots to the desktop"
defaults write com.apple.screencapture location -string "${HOME}/Desktop"

echo -e "\t- Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)"
defaults write com.apple.screencapture type -string "png"

echo -e "\t- Disable shadow in screenshots"
defaults write com.apple.screencapture disable-shadow -bool true

###############################################################################
echo
echo -e "\t Finder"
echo -e "\t #################################"
echo
###############################################################################

echo -e "\t- Finder: allow quitting via ⌘ + Q; doing so will also hide desktop icons"
defaults write com.apple.finder QuitMenuItem -bool true

echo -e "\t- Finder: disable window animations and Get Info animations"
defaults write com.apple.finder DisableAllAnimations -bool true

echo -e "\t- Set home folder as the default location for new Finder windows"
# For other paths, use `PfLo` and `file:///full/path/here/`
defaults write com.apple.finder NewWindowTarget -string "PfDe"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

echo -e "\t- Showing all filename extensions in Finder by default"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

echo -e "\t- Showing status bar in Finder by default"
defaults write com.apple.finder ShowStatusBar -bool true

echo -e "\t- Showing path bar in Finder by default"
defaults write com.apple.finder ShowPathbar -bool true

echo -e "\t- Allowing text selection in Quick Look/Preview in Finder by default"
defaults write com.apple.finder QLEnableTextSelection -bool true

echo -e "\t- Displaying full POSIX path as Finder window title"
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

echo -e "\t- Keep folders on top when sorting by name"
defaults write com.apple.finder _FXSortFoldersFirst -bool true

echo -e "\t- When performing a search, search the current folder by default"
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

echo -e "\t- Enable spring loading for directories"
defaults write NSGlobalDomain com.apple.springing.enabled -bool true

echo -e "\t- Disable disk image verification"
defaults write com.apple.frameworks.diskimages skip-verify -bool true
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

echo -e "\t- Automatically open a new Finder window when a volume is mounted"
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

echo -e "\t- Enable AirDrop over Ethernet and on unsupported Macs running Lion"
defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

echo -e "\t- Disabling the warning when changing a file extension"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

echo -e "\t- Use list view in all Finder windows by default"
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

echo -e "\t- Avoiding the creation of .DS_Store files on network volumes"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

echo -e "\t- Avoiding the creation of .DS_Store files on USB volumes"
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

echo -e "\t- Show hidden files in all Finder windows by default"
defaults write com.apple.finder AppleShowAllFiles -bool true

echo -e "\t- Show item info near icons on the desktop and in other icon views"
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist

echo -e "\t- Expand the following File Info panes: 'General', 'Open with', and 'Sharing & Permissions'"
defaults write com.apple.finder FXInfoPanesExpanded -dict \
	General -bool true \
	OpenWith -bool true \
	Privileges -bool true

echo -e "\t- Enabling snap-to-grid for icons on the desktop and in other icon views"
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

echo -e "\t- Showing the ~/Library folder"
chflags nohidden ~/Library

echo -e "\t- Showing the /Volumes folder"
sudo chflags nohidden /Volumes

# Kill all finder instances to reload the new configuration
killall Finder

###############################################################################
echo
echo -e "\t Dock, Dashboard, and hot corners"
echo -e "\t #################################"
echo
###############################################################################

echo -e "\t- Enable highlight hover effect for the grid view of a stack (Dock)"
defaults write com.apple.dock mouse-over-hilite-stack -bool true

echo -e "\t- Set the icon size of Dock items to 36 pixels"
defaults write com.apple.dock tilesize -int 36

echo -e "\t- Change minimize/maximize window effect"
defaults write com.apple.dock mineffect -string "scale"

echo -e "\t- Minimize windows into their application’s icon"
defaults write com.apple.dock minimize-to-application -bool true

echo -e "\t- Enable spring loading for all Dock items"
defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true

echo -e "\t- Show indicator lights for open applications in the Dock"
defaults write com.apple.dock show-process-indicators -bool true

echo -e "\t- Wipe all (default) app icons from the Dock"
# This is only really useful when setting up a new Mac, or if you don’t use
# the Dock to launch apps.
defaults write com.apple.dock persistent-apps -array

echo -e "\t- Show only open applications in the Dock"
defaults write com.apple.dock static-only -bool true

echo -e "\t- Don’t animate opening applications from the Dock"
defaults write com.apple.dock launchanim -bool false

echo -e "\t- Speed up Mission Control animations"
defaults write com.apple.dock expose-animation-duration -float 0.1

echo -e "\t- Don’t group windows by application in Mission Control"
# (i.e. use the old Exposé behavior instead)
defaults write com.apple.dock expose-group-by-app -bool false

echo -e "\t- Disable Dashboard"
defaults write com.apple.dashboard mcx-disabled -bool true

echo -e "\t- Don’t show Dashboard as a Space"
defaults write com.apple.dock dashboard-in-overlay -bool true

echo -e "\t- Don’t automatically rearrange Spaces based on most recent use"
defaults write com.apple.dock mru-spaces -bool false

echo -e "\t- Remove the auto-hiding Dock delay"
defaults write com.apple.dock autohide-delay -float 0

echo -e "\t- Remove the animation when hiding/showing the Dock"
defaults write com.apple.dock autohide-time-modifier -float 0

echo -e "\t- Automatically hide and show the Dock"
defaults write com.apple.dock autohide -bool true

echo -e "\t- Make Dock icons of hidden applications translucent"
defaults write com.apple.dock showhidden -bool true

echo -e "\t- Disable the Launchpad gesture (pinch with thumb and three fingers)"
defaults write com.apple.dock showLaunchpadGestureEnabled -int 0

echo -e "\t- Reset Launchpad, but keep the desktop wallpaper intact"
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
echo -e "\t- Hot corners: Top left screen corner → Put display to sleep"
defaults write com.apple.dock wvous-tl-corner -int 10
defaults write com.apple.dock wvous-tl-modifier -int 0

###############################################################################
echo
echo -e "\t Safari & WebKit"
echo -e "\t #################################"
echo
###############################################################################

echo -e "\t- Privacy: don’t send search queries to Apple"
defaults write com.apple.Safari UniversalSearchEnabled -bool false
defaults write com.apple.Safari SuppressSearchSuggestions -bool true

echo -e "\t- Press Tab to highlight each item on a web page"
defaults write com.apple.Safari WebKitTabToLinksPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2TabsToLinks -bool true

echo -e "\t- Show the full URL in the address bar (note: this still hides the scheme)"
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

echo -e "\t- Set Safari’s home page to `about:blank` for faster loading"
defaults write com.apple.Safari HomePage -string "about:blank"

echo -e "\t- Prevent Safari from opening ‘safe’ files automatically after downloading"
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

echo -e "\t- Allow hitting the Backspace key to go to the previous page in history"
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2BackspaceKeyNavigationEnabled -bool true

echo -e "\t- Hide Safari’s bookmarks bar by default"
defaults write com.apple.Safari ShowFavoritesBar -bool false

echo -e "\t- Hide Safari’s sidebar in Top Sites"
defaults write com.apple.Safari ShowSidebarInTopSites -bool false

echo -e "\t- Disable Safari’s thumbnail cache for History and Top Sites"
defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2

echo -e "\t- Enable Safari’s debug menu"
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

echo -e "\t- Make Safari’s search banners default to Contains instead of Starts With"
defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false

echo -e "\t- Remove useless icons from Safari’s bookmarks bar"
defaults write com.apple.Safari ProxiesInBookmarksBar "()"

echo -e "\t- Enable the Develop menu and the Web Inspector in Safari"
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

echo -e "\t- Add a context menu item for showing the Web Inspector in web views"
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

echo -e "\t- Enable continuous spellchecking"
defaults write com.apple.Safari WebContinuousSpellCheckingEnabled -bool true

echo -e "\t- Disable auto-correct"
defaults write com.apple.Safari WebAutomaticSpellingCorrectionEnabled -bool false

echo -e "\t- Disable AutoFill"
defaults write com.apple.Safari AutoFillFromAddressBook -bool false
defaults write com.apple.Safari AutoFillPasswords -bool false
defaults write com.apple.Safari AutoFillCreditCardData -bool false
defaults write com.apple.Safari AutoFillMiscellaneousForms -bool false

echo -e "\t- Warn about fraudulent websites"
defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool true

echo -e "\t- Enable 'Do Not Track'"
defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true

echo -e "\t- Update extensions automatically"
defaults write com.apple.Safari InstallExtensionUpdatesAutomatically -bool true

###############################################################################
echo
echo -e "\t Mail"
echo -e "\t #################################"
echo
###############################################################################

echo -e "\t- Disable send and reply animations in Mail.app"
defaults write com.apple.mail DisableReplyAnimations -bool true
defaults write com.apple.mail DisableSendAnimations -bool true

echo -e "\t- Copy email addresses as 'foo@example.com' instead of 'Foo Bar <foo@example.com>' in Mail.app"
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

echo -e "\t- Add the keyboard shortcut ⌘ + Enter to send an email in Mail.app"
defaults write com.apple.mail NSUserKeyEquivalents -dict-add "Send" "@\U21a9"

echo -e "\t- Display emails in threaded mode, sorted by date (newest at the top)"
defaults write com.apple.mail InboxViewerAttributes -dict-add "DisplayInThreadedMode" -string "yes"
defaults write com.apple.mail InboxViewerAttributes -dict-add "SortedDescending" -string "no"
defaults write com.apple.mail InboxViewerAttributes -dict-add "SortOrder" -string "received-date"

defaults write com.apple.mail DraftsViewerAttributes -dict-add "DisplayInThreadedMode" -string "yes"
defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortedDescending" -string "no"
defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortOrder" -string "received-date"

defaults write com.apple.mail ArchiveViewerAttributes -dict-add "DisplayInThreadedMode" -string "yes"
defaults write com.apple.mail ArchiveViewerAttributes -dict-add "SortedDescending" -string "no"
defaults write com.apple.mail ArchiveViewerAttributes -dict-add "SortOrder" -string "received-date"

echo -e "\t- Display emails sorted by date (newest at the top) inside a thread"
defaults write com.apple.mail ConversationViewSortDescending -int 1

echo -e "\t- Do not play mail sounds"
defaults write com.apple.mail PlayMailSounds -int 0
defaults write com.apple.mail NewMessagesSoundName -string ""

echo -e "\t- Disable inline attachments (just show the icons)"
defaults write com.apple.mail DisableInlineAttachmentViewing -bool true

echo -e "\t- Disable automatic spell checking"
defaults write com.apple.mail SpellCheckingBehavior -string "NoSpellCheckingEnabled"

###############################################################################
echo
echo -e "\t Spotlight"
echo -e "\t #################################"
echo
###############################################################################

echo -e "\t- Disable Spotlight indexing for any volume that gets mounted and has not yet been indexed before."
# Use `sudo mdutil -i off "/Volumes/foo"` to stop indexing any volume.
sudo defaults write /.Spotlight-V100/VolumeConfiguration Exclusions -array "/Volumes"

echo -e "\t- Change indexing order and disable some search results"
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

echo -e "\t- Load new settings before rebuilding the index"
sudo killall mds > /dev/null 2>&1

echo -e "\t- Make sure indexing is enabled for the main volume"
sudo mdutil -i on / > /dev/null

echo -e "\t- Rebuild the index from scratch"
sudo mdutil -E / > /dev/null

###############################################################################
echo
echo -e "\t Terminal"
echo -e "\t #################################"
echo
###############################################################################

echo -e "\t- Only use UTF-8 in Terminal.app"
defaults write com.apple.terminal StringEncodings -array 4

echo -e "\t- Use a modified version of the Solarized Dark theme by default in Terminal.app"
osascript <<EOD

tell application "Terminal"

	local allOpenedWindows
	local initialOpenedWindows
	local windowID
	set themeName to "Solarized Dark xterm-256color"

	(* Store the IDs of all the open terminal windows. *)
	set initialOpenedWindows to id of every window

	(* Open the custom theme so that it gets added to the list
	   of available terminal themes (note: this will open two
	   additional terminal windows). *)
	do shell script "open '$HOME/init/" & themeName & ".terminal'"

	(* Wait a little bit to ensure that the custom theme is added. *)
	delay 1

	(* Set the custom theme as the default terminal theme. *)
	set default settings to settings set themeName

	(* Get the IDs of all the currently opened terminal windows. *)
	set allOpenedWindows to id of every window

	repeat with windowID in allOpenedWindows

		(* Close the additional windows that were opened in order
		   to add the custom theme to the list of terminal themes. *)
		if initialOpenedWindows does not contain windowID then
			close (every window whose id is windowID)

		(* Change the theme for the initial opened terminal windows
		   to remove the need to close them in order for the custom
		   theme to be applied. *)
		else
			set current settings of tabs of (every window whose id is windowID) to settings set themeName
		end if

	end repeat

end tell

EOD

echo -e "\t- Enable Secure Keyboard Entry in Terminal.app"
# See: https://security.stackexchange.com/a/47786/8918
defaults write com.apple.terminal SecureKeyboardEntry -bool true

echo -e "\t- Disable the annoying line marks"
defaults write com.apple.Terminal ShowLineMarks -int 0

###############################################################################
echo
echo -e "\t Time Machine"
echo -e "\t #################################"
echo
###############################################################################

echo -e "\t- Prevent Time Machine from prompting to use new hard drives as backup volume"
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

###############################################################################
echo
echo -e "\t Activity Monitor"
echo -e "\t #################################"
echo
###############################################################################

echo -e "\t- Show the main window when launching Activity Monitor"
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

echo -e "\t- Visualize CPU usage in the Activity Monitor Dock icon"
defaults write com.apple.ActivityMonitor IconType -int 5

echo -e "\t- Show all processes in Activity Monitor"
defaults write com.apple.ActivityMonitor ShowCategory -int 0

echo -e "\t- Sort Activity Monitor results by CPU usage"
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

###############################################################################
echo
echo -e "\t Address Book, Dashboard, iCal, TextEdit, and Disk Utility"
echo -e "\t #################################"
echo
###############################################################################

echo -e "\t- Enable the debug menu in Address Book"
defaults write com.apple.addressbook ABShowDebugMenu -bool true

echo -e "\t- Enable Dashboard dev mode (allows keeping widgets on the desktop)"
defaults write com.apple.dashboard devmode -bool true

echo -e "\t- Enable the debug menu in iCal (pre-10.8)"
defaults write com.apple.iCal IncludeDebugMenu -bool true

echo -e "\t- Use plain text mode for new TextEdit documents"
defaults write com.apple.TextEdit RichText -int 0

echo -e "\t- Open and save files as UTF-8 in TextEdit"
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

echo -e "\t- Enable the debug menu in Disk Utility"
defaults write com.apple.DiskUtility DUDebugMenuEnabled -bool true
defaults write com.apple.DiskUtility advanced-image-options -bool true

###############################################################################
echo
echo -e "\t Mac App Store"
echo -e "\t #################################"
echo
###############################################################################

echo -e "\t- Enable the WebKit Developer Tools in the Mac App Store"
defaults write com.apple.appstore WebKitDeveloperExtras -bool true

echo -e "\t- Enable Debug Menu in the Mac App Store"
defaults write com.apple.appstore ShowDebugMenu -bool true

echo -e "\t- Enable the automatic update check"
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

echo -e "\t- Check for software updates daily, not just once per week"
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

echo -e "\t- Download newly available updates in background"
defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1

echo -e "\t- Install System data files & security updates"
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1

echo -e "\t- Turn on app auto-update"
defaults write com.apple.commerce AutoUpdate -bool true

echo -e "\t- Allow the App Store to reboot machine on macOS updates"
defaults write com.apple.commerce AutoUpdateRestartRequired -bool true

###############################################################################
echo
echo -e "\t Photos"
echo -e "\t #################################"
echo
###############################################################################

echo -e "\t- Prevent Photos from opening automatically when devices are plugged in"
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

###############################################################################
echo
echo -e "\t Messages"
echo -e "\t #################################"
echo
###############################################################################

echo -e "\t- Disable smart quotes as it's annoying for messages that contain code"
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticQuoteSubstitutionEnabled" -bool false

# Disable continuous spell checking
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "continuousSpellCheckingEnabled" -bool false

###############################################################################
echo
echo -e "\t Google Chrome"
echo -e "\t #################################"
echo

echo -e "\t- Disable the all too sensitive backswipe on trackpads"
defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false

echo -e "\t- Disable the all too sensitive backswipe on Magic Mouse"
defaults write com.google.Chrome AppleEnableMouseSwipeNavigateWithScrolls -bool false

echo -e "\t- Use the system-native print preview dialog"
defaults write com.google.Chrome DisablePrintPreview -bool true

echo -e "\t- Expand the print dialog by default"
defaults write com.google.Chrome PMPrintingExpandedStateForPrint2 -bool true


###############################################################################
echo
echo -e "\t OSX defaults applied. Please do a restart after these changes."
echo -e "\t #################################"
echo
