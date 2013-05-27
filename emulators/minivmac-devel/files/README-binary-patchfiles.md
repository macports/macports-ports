# Creating binary patches

* Boot Mini vMac with System 7

## 1. Create patch-Tidbits.image.bsdiff

* Get a fresh copy of Tidbits.image
* Make a copy called Tidbits.image.orig
* Mount Tidbits.image in Mini vMac
* Make the configure.args file:
  * Open TeachText on the Tidbits volume
  * Type "@START@", 8180 spaces, "@END@"
  * Save as "configure.args" on the Desktop of the Tidbits volume
  * Use "Get Info" in the Finder to verify the file is exactly 8192 bytes long
* Close all windows
* Unmount the Tidbits volume
* Run `bsdiff Tidbits.image.orig Tidbits.image patch-Tidbits.image.bsdiff`

## 2. Create patch-Disk Tools.image.bsdiff

* Get a fresh copy of Disk Tools.image
* Make a copy called Disk Tools.image.orig
* Mount Disk Tools.image in Mini vMac
* Make the configure.args alias:
  * Get a Tidbits.image patched to contain the configure.args file
  * Mount Tidbits.image in Mini vMac
  * Open the System Folder on the Disk Tools volume
  * Select the configure.args file on the Desktop
  * Choose Make Alias from the File menu
  * Copy or move the alias into the Startup Items folder
* [Disable Finder zoom rects](http://tidbits.com/static/html/TidBITS-099.html#lnk5):
  * Mount an image containing ResEdit
  * Open the Finder in ResEdit
  * Open CODE resource 4, decompressing it when prompted
  * Find hex 4E56 FFE0 48E7 1F38
  * Change to 205F 700A DEC0 4ED0
  * Save and quit
* Close all windows
* Unmount the Disk Tools volume
* Run `bsdiff 'Disk Tools.image.orig' 'Disk Tools.image' 'patch-Disk Tools.image.bsdiff'`
