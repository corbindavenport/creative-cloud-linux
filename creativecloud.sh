#!/usr/bin/env bash
# Author : Corbin Davenport
# Licence : GPLv3

# WINBIND ALSO NEEDS TO BE INSTALLED
# Other stuff: https://bugs.winehq.org/show_bug.cgi?id=47015 https://forum.winehq.org/viewtopic.php?f=8&t=32465
#sudo setcap cap_net_raw+epi "$(readlink -f "/usr/bin/wineserver")"
#find / -name wineserver64  2>&1 | grep -v "Permission denied" | grep -v "Invalid"

# 'gecko' argument can be added to use Wine Gecko instead of IE8

PREFIX="$HOME/CreativeCloud"
WINETRICKS="msxml3 atmlib corefonts fontsmooth=rgb gdiplus"
WINETRICKS_DOWNLOAD="https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks"
ADOBE_DOWNLOAD="http://ccmdl.adobe.com/AdobeProducts/KCCC/CCD/4_9/win32/ACCCx4_9_0_504.zip"
GECKO_32_DOWNLOAD="http://dl.winehq.org/wine/wine-gecko/2.47/wine_gecko-2.47-x86.msi"
GECKO_64_DOWNLOAD="http://dl.winehq.org/wine/wine-gecko/2.47/wine_gecko-2.47-x86_64.msi"

#TODO: Check Wine + winbind is installed

# Create directory
WINEVERSION=$(wine --version)
echo "[ OK ] Creative Cloud installer 1.0, running on $WINEVERSION"
mkdir $PREFIX
cd $PREFIX
#echo "test" >> test.txt

# Kill all Wine processes
wineserver -k; killall -9 wine wineserver; for i in `ps ax|egrep "*\.exe"|grep -v 'egrep'|awk '{print $1 }'`;do kill -9 $i;done

# Generate 32-bit WINE prefix
if [ "$1" = "gecko" ]; then
    if zenity --question --width=500 --title="Creative Cloud" --text="Adobe Creative Cloud has not been successfully installed using the Gecko option, are you sure you want to continue?"; then
        echo "[ OK ] Creating Wine prefix with Gecko..."
        WINEPREFIX=$PREFIX WINEARCH=win32 wine wineboot
    else
        exit
    fi
else
    echo "[ OK ] Creating Wine prefix without Gecko..."
    WINEPREFIX=$PREFIX WINEDLLOVERRIDES="mscoree,mshtml=" WINEARCH=win32 wine wineboot
fi
echo "[ OK ] Wine prefix created at $PREFIX"

# Download and run Winetricks
curl -Lfk --progress-bar -o "$PREFIX/winetricks" "$WINETRICKS_DOWNLOAD" || { echo "[EROR] Download failed."; exit; }
chmod +x ./winetricks
echo "[ OK ] Running Winetricks..."
WINEPREFIX=$PREFIX ./winetricks $WINETRICKS --unattended

# Download and install either IE or Gecko, depending on setting
if [ "$1" = "gecko" ]; then
    WINEPREFIX=$PREFIX ./winetricks vcrun2015 --unattended
    echo "[ OK ] Downloading Gecko rendering engine..."
    curl -Lfk --progress-bar -o "$PREFIX/gecko-32.msi" "$GECKO_32_DOWNLOAD" || { echo "[EROR] Download failed."; exit; }
    #curl -Lfk --progress-bar -o "$PREFIX/gecko-64.msi" "$GECKO_64_DOWNLOAD" || { echo "[EROR] Download failed."; exit; }
    echo "[ OK ] Installing Gecko..."
    WINEPREFIX=$PREFIX wine msiexec /i $PREFIX/gecko-32.msi
    #WINEPREFIX=$PREFIX wine msiexec /i $PREFIX/gecko-64.msi
else
    echo "[ OK ] Downloading and installing IE8..."
    WINEPREFIX=$PREFIX ./winetricks ie8 --unattended
    # Set DLL override
    zenity --info --width=500 --title="Creative Cloud" --text="The Wine configuration tool will now open. Follow these steps:\n\n1. Click the Libraries tab.\n3. Select 'wininet' in the list, and click Edit.\n4. Select 'Builtin' and click OK.\n5. Click OK to close Wine configuration.\n\nThis window will remain open until you click OK." &
    WINEPREFIX=$PREFIX winecfg
fi

# Download and unzip Adobe installer
mkdir "$PREFIX/install"
echo "[ OK ] Downloading installer for Adobe Creative Cloud..."
curl -Lfk --progress-bar -o "$PREFIX/install/install.zip" "$ADOBE_DOWNLOAD" || { echo "[EROR] Download failed."; exit; }
echo "[ OK ] Unzipping installer..."
unzip "$PREFIX/install/install.zip" -d $PREFIX/install

# Set OS version to Windows 7
echo "[ OK] Setting OS version to Windows 7..."
WINEPREFIX=$PREFIX ./winetricks win7 --unattended

# Run the installer
echo "[ OK ] Running installer..."
WINEPREFIX=$PREFIX WINEDEBUG=warn wine $PREFIX/install/Set-up.exe