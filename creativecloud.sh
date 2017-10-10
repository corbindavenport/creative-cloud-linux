#!/usr/bin/env bash
# Date : (2017-10-03)
# Distribution used to test : Ubuntu 17.10 x64
# Author : Corbin Davenport
# Licence : GPLv3
# PlayOnLinux: 4.2.12

# Based on RoninDusette's script
# from https://www.playonlinux.com/en/app-2316-Adobe_Photoshop_CS6.html

[ "$PLAYONLINUX" = "" ] && exit 0
source "$PLAYONLINUX/lib/sources"

PREFIX="CreativeCloud"
WINEVERSION="2.17-staging"
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
Set_OS "winxp"

# Install dependencies
POL_Call POL_Install_atmlib
POL_Call POL_Install_corefonts
POL_Call POL_Install_FontsSmoothRGB
POL_Call POL_Install_gdiplus

# Get the installer
POL_SetupWindow_message "$(eval_gettext 'On the next screen, you can choose between automatically downloading the Creative Cloud installer, or selecting it from your computer.\n\nIt is HIGHLY RECOMMENDED to let the script download the Creative Cloud installer for you, since the downloaded version has been verified to work.')" "$TITLE"
POL_SetupWindow_InstallMethod "LOCAL,DOWNLOAD"
if [ "$INSTALL_METHOD" = "LOCAL" ]
then
    # The normal Creative Cloud setup requires Windows 7 or higher
    Set_OS "win7"
    POL_SetupWindow_browse "Please select the Creative Cloud install program." "$TITLE"
    POL_SetupWindow_wait "Installation in progress..." "$TITLE"
    INSTALLER="$APP_ANSWER"
elif [ "$INSTALL_METHOD" = "DOWNLOAD" ]
then
    cd "$POL_System_TmpDir"
    # The Creative Cloud setup program from the Photoshop download link on Adobe's website only needs Windows XP, and seems to work better in Wine
    POL_Download "https://ccmdls.adobe.com/AdobeProducts/PHSP/18_1_1/win32/AAMmetadataLS20/CreativeCloudSet-Up.exe"
    POL_SetupWindow_wait "Installation in progress..." "$TITLE"
    INSTALLER="$POL_System_TmpDir/CreativeCloudSet-Up.exe"
fi
  
# Installation
POL_SetupWindow_message "$(eval_gettext 'IMPORTANT: Once Adobe Application Application Manager is installed and you finish logging in, come back to this setup window and click Next. Some final adjustments have to be made by the script in order to run newer Adobe programs.')" "$TITLE"
POL_Wine_WaitBefore "$TITLE"
POL_Wine "$INSTALLER"
POL_Shortcut "PDapp.exe" "Adobe Application Manager"
Set_OS "win7"
POL_System_TmpDelete

# All done
POL_SetupWindow_message "$(eval_gettext 'The installation is now complete, you can now use Adobe Application Manager to download and install the applications you need.\n\nYou will need to close and re-open Application Manager to see newer apps, like CC 2015.\n\nAfter you download an app, you can add a PlayOnLinux shortcut for it by clicking Adobe Application Manager in the app list, clicking CONFIGURE, and clicking MAKE A NEW SHORTCUT FROM THIS VIRTUAL DRIVE. Then look for the app, like Photoshop.exe, and add it.')" "$TITLE"
  
POL_SetupWindow_Close
exit 0
