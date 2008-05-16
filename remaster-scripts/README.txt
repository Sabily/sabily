* download the ubuntu ISO file:
http://releases.ubuntu.com/releases

* install UCK: http://uck.sourceforge.net/

* retrieve the scripts and resources:
bzr branch http://bazaar.launchpad.net/~ubuntume.team/ubuntume/hardy

* run the four scripts: "1.clean.sh", "2.init-build.sh",
"3.customize.sh", then "4.build-iso.sh". You should call them with 2 arguments:
ISO_IMAGE -> full path to the ubuntu iso file
ISO_NAME -> name of the final ISO file

for example: sudo ./1.clean.sh "fullPathToISO" "ubuntuME-vX.XX-desktop-i386.iso"

.... and you should have an UbuntuME ISO file (in the remaster-new-files folder) ;)
