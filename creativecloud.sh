#!/bin/bash
# Date : (2017-10-03)
# Distribution used to test : Ubuntu 17.10 x64
# Author : Corbin Davenport
# Licence : GPLv3
# PlayOnLinux: 4.2.12

# Based on RoninDusette's script
# from https://www.playonlinux.com/en/app-2316-Adobe_Photoshop_CS6.html

[ "$PLAYONLINUX" = "" ] && exit 0
source "$PLAYONLINUX/lib/sources"

PREFIX="CreativeCloudDev"
WINEVERSION="2.20-staging"
TITLE="Adobe Creative Cloud"
EDITOR="Adobe Systems Inc."
GAME_URL="http://www.adobe.com"
AUTHOR="Corbin Davenport"

#Initialization
POL_SetupWindow_Init
POL_SetupWindow_SetID 3251

POL_Debug_Init

# Presentation
POL_SetupWindow_presentation "$TITLE" "$EDITOR" "$GAME_URL" "$AUTHOR" "$PREFIX"

# Create prefix and temporary download folder
POL_Wine_SelectPrefix "$PREFIX"
POL_Wine_PrefixCreate "$WINEVERSION"
POL_System_TmpCreate "AppManagerTmp"
Set_OS "win7"

# Install dependencies
POL_Call POL_Install_msxml3

cd "$POL_System_TmpDir"
# Use winetricks, since the POL_corefonts version does not work with the installer
POL_Download_Resource  "https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks"
chmod +x winetricks 
./winetricks atmlib corefonts fontsmooth=rgb

# Get the installer
cd "$POL_System_TmpDir"
POL_Download "https://ccmdls.adobe.com/AdobeProducts/PHSP/19_1_1/win32/AAMmetadataLS20/CreativeCloudSet-Up.exe"
POL_SetupWindow_wait "Installation in progress..." "$TITLE"
INSTALLER="$POL_System_TmpDir/CreativeCloudSet-Up.exe"
  
# Installation
POL_SetupWindow_message "$(eval_gettext 'Once Adobe Application Application Manager is installed and you finish logging in, come back to this setup window and click Next. Some final adjustments have to be made by the script in order to run newer Adobe programs.\n\nThe troubleshooting page will also open in your web browser, in case you run into problems.')" "$TITLE"
POL_Browser "https://github.com/corbindavenport/creative-cloud-linux/wiki/Troubleshooting"
POL_Wine_WaitBefore "$TITLE"
POL_Wine "$INSTALLER"
POL_Shortcut "Creative Cloud.exe" "[DEV] Adobe Application Manager"
Set_OS "win7"
POL_System_TmpDelete

# All done
POL_SetupWindow_message "$(eval_gettext 'The installation is now complete, you can now use Adobe Application Manager to download and install the applications you need.\n\nLoading the login screen or the Application List can take some time, just give it a minute.\n\nAfter you download an app, you can add a PlayOnLinux shortcut for it by clicking Adobe Application Manager in the app list, clicking CONFIGURE, and clicking MAKE A NEW SHORTCUT FROM THIS VIRTUAL DRIVE. Then look for the app, like Photoshop.exe, and add it.')" "$TITLE"
 
POL_SetupWindow_Close
exit 0
