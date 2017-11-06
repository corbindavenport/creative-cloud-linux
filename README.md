This is the in-progress development version of the Creative Cloud Script, designed to allow newer CC apps (like Photoshop CC 2017) to run. This script can be installed alongside the one found in the master branch. **This dev version does not work right now.**

Changes in this version:

* Set default OS to Windows 7
* Added wintrust, msasn1, winhttp, wininet, and vcrun2008 packages from [POL function repository](https://www.playonlinux.com/repository/?cat=100) to fix some errors with the installer
* Download the actual Creative Cloud installer program from Adobe, instead of an older Photoshop installer
* Removed option to choose a local install .exe

The key to getting newer Adobe software working is to use the updated Creative Cloud desktop application. The stable version of this script installs the older 'Adobe Application Manager,' which only allows CC 2015 apps and older to be downloaded.

Even with the current changes to the script, the Creative Cloud installer still fails every time, either at 3% with a Wine crash or at 5% with a download error.

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