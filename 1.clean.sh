#!/bin/bash

# To run this script you should call it with three parameters:
# REMASTER_HOME -> full path to the directory where this script resides
# ISO_IMAGE -> full path to the ubuntu iso file
# ISO_NAME -> name of the final ISO file
#
# For example:
# sudo ./1.clean.sh "fullPathToDir" "fullPathToISO" "ubuntuME-vX.XX-desktop-i386.iso"

REMASTER_HOME=$1
ISO_IMAGE=$2
ISO_NAME=$3
CUSTOMIZE_DIR="$REMASTER_HOME/customization-scripts"

##################
# some functions #
##################

function check_exit_code()
{
	RESULT=$?
	if [ "$RESULT" -ne 0 ]; then
		exit "$RESULT"
	fi
}

function check_if_user_is_root()
{
	if [ `id -un` != "root" ]; then
		echo "You need root privileges"
		exit 2
	fi
}

########
# main #
########

check_if_user_is_root

if [ -e libraries/remaster-live-cd.sh ]; then
	SCRIPTS_DIR=`dirname "$0"`
else
	SCRIPTS_DIR=/usr/bin
fi

echo "Starting CD remastering on " `date`
echo "Customization dir=$CUSTOMIZE_DIR"

CUSTOMIZE_ROOTFS="no"
CUSTOMIZE_INITRD="no"
CUSTOMIZE_ISO="no"
REMOVE_WIN32_FILES=`cat "$CUSTOMIZE_DIR/remove_win32_files"`
CLEAN_DESKTOP_MANIFEST="no"

if [ -e "$CUSTOMIZE_DIR/customize" ]; then
	CUSTOMIZE_ROOTFS="yes"
fi

if [ -e "$CUSTOMIZE_DIR/customize_initrd" ]; then
	CUSTOMIZE_INITRD="yes"
fi

if [ -e "$CUSTOMIZE_DIR/customize_iso" ]; then
	CUSTOMIZE_ISO="yes"
fi

if [ -e "$CUSTOMIZE_DIR/clean_desktop_manifest" ]; then
	CLEAN_DESKTOP_MANIFEST="yes"
fi

$SCRIPTS_DIR/uck-remaster-clean "$REMASTER_HOME"
check_exit_code


exit 0
