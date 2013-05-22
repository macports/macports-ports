# Creating binary patches

## 1. Create patch-Tidbits.image.bsdiff

* Get a fresh copy of Tidbits.image
* Make a copy called Tidbits.image.orig
* Boot Mini vMac with Disk Tools.image
* Mount Tidbits.image
* Open TeachText on the Tidbits volume
* Type "@START@", 8180 spaces, "@END@"
* Save as "configure.args" on the Desktop of the Tidbits volume
* Use "Get Info" in the Finder to verify the file is exactly 8192 bytes long
* Close all windows
* Shut down the emulator
* Run `bsdiff Tidbits.image.orig Tidbits.image patch-Tidbits.image.bsdiff`

## 2. Create patch-Disk Tools.image.bsdiff

* Get a fresh copy of Disk Tools.image
* Make a copy called Disk Tools.image.orig
* Boot Mini vMac with Disk Tools.image
* Get a Tidbits.image patched to contain the configure.args file
* Mount Tidbits.image
* Open the System Folder on the Disk Tools volume
* Select the configure.args file on the Desktop
* Choose Make Alias from the File menu
* Copy or move the alias into the Startup Items folder
* Close all windows
* Shut down the emulator
* Run `bsdiff 'Disk Tools.image.orig' 'Disk Tools.image' 'patch-Disk Tools.image.bsdiff'`
