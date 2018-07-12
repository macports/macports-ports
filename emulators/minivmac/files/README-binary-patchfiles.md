# Creating binary patches

## Prerequisites

* A copy of Mini vMac with support for writing to Disk Copy 4.2 images: either a version earlier than 3.2.2, or version 3.2.2 or later compiled with the build options `-sony-sum 1 -sony-tag 1`. The default Gryphel builds do not use these options but the default MacPorts builds do.
* Disk Tools.image and Tidbits.image disk images from the System 7.0.1.smi disk image from Apple's legacy download area.
* autquit7-1.3.1.dsk (or other version) and the latest minivmac*.src.dsk disk images from the Mini vMac web site.
* A disk image with a copy of ResEdit 2.1.3 (optional).

## Create patch-autquit7-1.3.1.dsk.bsdiff

* Boot Mini vMac with Disk Tools.image
* Get a fresh copy of autquit7-1.3.1.dsk
* Make a copy called autquit7-1.3.1.dsk.orig
* Mount autquit7-1.3.1.dsk in Mini vMac
* Make the "app" alias:
  * Get the latest minivmac*.src.dsk
  * Mount minivmac*.src.dsk in Mini vMac
  * Select the MnvM_b35 application on the MnvM_b35 volume
  * Choose Make Alias from the File menu
  * Rename the alias to "app"
  * Copy the alias to the AutQuit7 volume
* Make the "doc" file:
  * Mount Tidbits.image in Mini vMac
  * Open TeachText on the Tidbits volume
  * Type "@START@", 8180 spaces and/or periods, "@END@"
  * Save as "doc" on the AutQuit7 volume
  * Use "Get Info" in the Finder to verify the file is exactly 8192 bytes long
* Close all windows
* Choose Shut Down from the Special menu
* Run `bsdiff autquit7-1.3.1.dsk.orig autquit7-1.3.1.dsk patch-autquit7-1.3.1.dsk.bsdiff`

## Create patch-Disk Tools.image.bsdiff

* Get a fresh copy of Disk Tools.image
* Make a copy called Disk Tools.image.orig
* Boot Mini vMac with Disk Tools.image
* Make the AutQuit7 alias:
  * Mount autquit7-1.3.1.dsk in Mini vMac
  * Select the AutQuit7 application on the AutQuit7 volume
  * Choose Make Alias from the File menu
  * Open the System Folder on the Disk Tools volume
  * Copy the alias into the Startup Items folder
* [Disable Finder zoom rects](http://tidbits.com/static/html/TidBITS-099.html#lnk5) (optional, now that the build script no longer depends on precise timing):
  * Mount an image containing ResEdit
  * Open the Finder in ResEdit
  * Open CODE resource 4, decompressing it when prompted
  * Find hex 4E56 FFE0 48E7 1F38
  * Change to 205F 700A DEC0 4ED0
  * Save and quit
* Close all windows
* Choose Shut Down from the Special menu
* Run `bsdiff 'Disk Tools.image.orig' 'Disk Tools.image' 'patch-Disk Tools.image.bsdiff'`
