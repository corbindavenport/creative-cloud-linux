#!/usr/bin/env bash
# Author : Corbin Davenport
# Licence : GPLv3

# WINBIND ALSO NEEDS TO BE INSTALLED
# Other stuff: https://bugs.winehq.org/show_bug.cgi?id=47015 https://forum.winehq.org/viewtopic.php?f=8&t=32465

PREFIX="$HOME/CreativeCloud"
WINETRICKS="msxml3 atmlib corefonts fontsmooth=rgb gdiplus crypt32 win10"
WINETRICKS_DOWNLOAD="https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks"
ADOBE_DOWNLOAD="https://prod-rel-ffc-ccm.oobesaas.adobe.com/adobe-ffc-external/core/v1/wam/download?sapCode=KCCC&productName=Creative%20Cloud&os=win"
GECKO_32_DOWNLOAD="http://dl.winehq.org/wine/wine-gecko/2.47/wine_gecko-2.47-x86.msi"
#TODO: Check Wine is installed

# Create directory
WINEVERSION=$(wine --version)
echo "[ OK ] Creative Cloud installer 1.0, running on $WINEVERSION"
mkdir $PREFIX
cd $PREFIX
#echo "test" >> test.txt

# Generate WINE prefix
WINEPREFIX=$PREFIX WINEARCH=win32 wine wineboot
echo "[ OK ] Wine prefix created at $PREFIX"

# Download and run Winetricks
curl -Lfk --progress-bar -o "$PREFIX/winetricks" "$WINETRICKS_DOWNLOAD" || { echo "[EROR] Download failed."; exit; }
chmod +x ./winetricks
echo "[ OK ] Running Winetricks..."
WINEPREFIX=$PREFIX WINEARCH=win32 ./winetricks $WINETRICKS --unattended

# Download and run Gecko installer
echo "[ OK ] Downloading Gecko rendering engine..."
curl -Lfk --progress-bar -o "$PREFIX/gecko-32.msi" "$GECKO_32_DOWNLOAD" || { echo "[EROR] Download failed."; exit; }
echo "[ OK ] Installing Gecko..."
WINEPREFIX=$PREFIX wine msiexec /i $PREFIX/gecko-32.msi

# Download and run Adobe installer
echo "[ OK ] Downloading installer for Adobe Creative Cloud..."
curl -Lfk --progress-bar -o "$PREFIX/install.exe" "$ADOBE_DOWNLOAD" || { echo "[EROR] Download failed."; exit; }
echo "[ OK ] Running installer..."
WINEPREFIX=$PREFIX WINEDEBUG=warn wine $PREFIX/install.exe

#TODO: Test installing cert file to save remote cert: https://serverfault.com/a/129505
# and install it to host: https://askubuntu.com/a/94861