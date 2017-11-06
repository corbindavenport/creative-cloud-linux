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
Set_OS "win7"

# Install dependencies
POL_Call POL_Install_atmlib
POL_Call POL_Install_corefonts
POL_Call POL_Install_FontsSmoothRGB
POL_Call POL_Install_wintrust
POL_Call POL_Install_msasn1
POL_Call POL_Install_vcrun2008
# The 'POL_Install_winhttp' command seems to go to a dead link, this is a modifed version:
POL_Download_Resource "https://web.archive.org/web/20061224003406/http://download.microsoft.com/download/5/0/c/50c42d0e-07a8-4a2b-befb-1a403bd0df96/IE5.01sp4-KB871260-Windows2000sp4-x86-ENU.exe" "0c0f6e300800e49472e9b2e0890a09c1" "0c0f6e300800e49472e9b2e0890a09c1"
   
cd "$WINEPREFIX/drive_c/windows/temp"
cabextract "$POL_USER_ROOT/ressources/IE5.01sp4-KB871260-Windows2000sp4-x86-ENU.exe" -F WINHTTP.DLL
if [ "$POL_ARCH" = "amd64" ]; then
        cp -f WINHTTP.DLL ../syswow64/winhttp.dll
else
        cp -f WINHTTP.DLL ../system32/winhttp.dll
fi
POL_Wine_OverrideDLL "native, builtin" "winhttp"
# End custom winhttp
# The 'POL_Install_wininet' command seems to go to a dead link, this is a modifed version:
POL_Download_Resource "https://web.archive.org/web/20061224003406/http://download.microsoft.com/download/5/0/c/50c42d0e-07a8-4a2b-befb-1a403bd0df96/IE5.01sp4-KB871260-Windows2000sp4-x86-ENU.exe" "0c0f6e300800e49472e9b2e0890a09c1"
cd "$WINEPREFIX/drive_c/windows/temp"
cabextract "$POL_USER_ROOT/ressources/IE5.01sp4-KB871260-Windows2000sp4-x86-ENU.exe" -F WININET.DLL
if [ "$POL_ARCH" = "amd64" ]; then
        cp -f WININET.DLL ../syswow64/wininet.dll
else
        cp -f WININET.DLL ../system32/wininet.dll
fi
POL_Wine_OverrideDLL "native, builtin" "wininet"
# End custom inet

# Get the installer
cd "$POL_System_TmpDir"
POL_Download "https://ccmdls.adobe.com/AdobeProducts/KCCC/1/win32/CreativeCloudSet-Up.exe"
POL_SetupWindow_wait "Installation in progress..." "$TITLE"
INSTALLER="$POL_System_TmpDir/CreativeCloudSet-Up.exe"
  
# Installation
POL_SetupWindow_message "$(eval_gettext 'Once Adobe Application Application Manager is installed and you finish logging in, come back to this setup window and click Next. Some final adjustments have to be made by the script in order to run newer Adobe programs.\n\nThe troubleshooting page will also open in your web browser, in case you run into problems.')" "$TITLE"
POL_Browser "https://github.com/corbindavenport/creative-cloud-linux/wiki/Troubleshooting"
POL_Wine_WaitBefore "$TITLE"
POL_Wine "$INSTALLER"
POL_Shortcut "PDapp.exe" "[DEV] Adobe Application Manager"
Set_OS "win7"
POL_System_TmpDelete

# All done
POL_SetupWindow_message "$(eval_gettext 'The installation is now complete, you can now use Adobe Application Manager to download and install the applications you need.\n\nYou will need to close and re-open Application Manager to see newer apps, like CC 2015.\n\nAfter you download an app, you can add a PlayOnLinux shortcut for it by clicking Adobe Application Manager in the app list, clicking CONFIGURE, and clicking MAKE A NEW SHORTCUT FROM THIS VIRTUAL DRIVE. Then look for the app, like Photoshop.exe, and add it.')" "$TITLE"
  
POL_SetupWindow_Close
exit 0