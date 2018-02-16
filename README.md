# Creative Cloud for PlayOnLinux

This is an install script for [Adobe Creative Cloud](https://www.adobe.com/creativecloud.html), designed to be used with [PlayOnLinux](https://www.playonlinux.com). The script sets up the Adobe Creative Cloud desktop program, which can be used to install and update Photoshop, Lightroom, Dreamweaver, Illustrator, and other apps.

**NOTE:** Only Photoshop CC, Bridge CC, Lightroom 5, and the Creative Cloud manager have been extensively tested. The newest Lightroom CC app is not supported right now. File syncing currently [does not work](https://github.com/corbindavenport/creative-cloud-linux/issues/29).

![Photoshop CC Screenshot](https://i.imgur.com/0JUQYuR.png)

A (free) Adobe ID is required. Most Adobe applications require [a paid subscription](https://www.adobe.com/creativecloud/plans.html).

## How to use this script

1. Download PlayOnLinux from your distribution's package manager (e.g. Ubuntu Software Center) or from [the PlayOnLinux website](https://www.playonlinux.com/en/download.html)
2. Save the [install script](https://raw.githubusercontent.com/corbindavenport/creative-cloud-linux/master/creativecloud.sh) to your computer
3. Open PlayOnLinux, go to Tools > Run a local script
4. Select the install script you just downloaded

After the setup process is finished, you can open `Adobe Creative Cloud` from PlayOnLinux to download and install the apps you need. After you download an app, you can add a PlayOnLinux shortcut for it by clicking Adobe Application Manager in the app list, clicking `Configure`, and clicking `Make a new shortcut from this virtual drive`. Then look for the app you need, like Photoshop.exe, and add it.

**Tip:** Tooltips in Photoshop might not disappear automatically. You can turn off tooltips completely by going to `Edit > Preferences > Tools` and un-checking the `Show tooltips` box.

If the installer crashes, see the [Troubleshooting page](https://github.com/corbindavenport/creative-cloud-linux/wiki/Troubleshooting).

---------------------------------------

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
