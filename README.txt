* download the ubuntu 8.04 beta ISO file:
http://releases.ubuntu.com/releases/8.04/

* install UCK: http://uck.sourceforge.net/

* retrieve the scripts and resources:
bzr branch http://bazaar.launchpad.net/~ubuntume.team/ubuntume/hardy

* run the four scripts: "1.clean.sh", "2.init-build.sh",
"3.customize.sh", then "4.build-iso.sh". You should call them with 3 arguments:
REMASTER_HOME -> full path to the directory where this script resides
ISO_IMAGE -> full path to the ubuntu iso file
ISO_NAME -> name of the final ISO file

for example: sudo ./1.clean.sh "fullPathToDir" "fullPathToISO" "ubuntuME-vX.XX-desktop-i386.iso"

.... and you should have an UbuntuME 8.04 ISO file (in the remaster-new-files folder) ;)
