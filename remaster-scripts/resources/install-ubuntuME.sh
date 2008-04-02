#!/bin/bash

ROOT_UID=0
SOURCES="/etc/apt/sources.list"
SOURCES_TMP="/tmp/sources.txt"
SOURCES_BACKUP="/etc/apt/sources.list.backup.ubuntume"
EXISTS="no"
RECOMMENT="no"

if grep -q "hardy" /etc/issue ; then VERSION="gutsy"
elif grep -q "7.10" /etc/issue ; then VERSION="gutsy"
elif grep -q "7.04" /etc/issue ; then VERSION="feisty"
elif grep -q "6.10" /etc/issue ; then VERSION="edgy"
elif grep -q "6.06" /etc/issue ; then VERSION="dapper"
else 
	echo "UbuntuME is only tested on Dapper, Edgy, Feisty and Gutsy. If you are using an older (or newer testing) release consider changing"
	exit 1
fi

# Need sudo privileges
if [ "$UID" -ne "$ROOT_UID" ]
then
  echo "Must have sudo privileges to run this script. Try sudo ./install-ubuntume.sh"
  exit $E_NOTROOT
fi  

#Make sure no processes which will conflict are running
function conflict_check {
sleep 1
if ps -U root -u root u | grep "synaptic" | grep -v grep > /dev/null;
then echo "Installation didn't work. Close Synaptic first then try again.";
exit 1;
elif ps -U root -u root u | grep "update-manager" | grep -v grep > /dev/null;
then echo "Installation didn't work. Close update-manager first then try again.";
exit 1;
elif ps -U root -u root u | grep "apt-get" | grep -v grep > /dev/null;
then echo "Installation didn't work. Wait for apt-get to finish running, or exit it, then try again.";
exit 1;
elif ps -U root -u root u | grep "dpkg" | grep -v grep > /dev/null;
then
   killall -9 dpkg
   sleep 1
   if ps -U root -u root u | grep "dpkg" | grep -v grep > /dev/null;
   then echo "Installation didn't work. Exit any independant instances of dpkg";
       exit 1;
   fi
fi
}

conflict_check

echo "Preparing for install..."

#Sort out sources.list
cat $SOURCES > $SOURCES_TMP
echo "" >> $SOURCES_TMP

if grep -q "http://www.ubuntume.com/repository" $SOURCES_TMP ; then EXISTS="yes"
else
 	echo "Adding UbuntuME repositories to sources.list" 
	echo "#Ubuntu Muslim Edition" >> $SOURCES_TMP
 	echo "deb http://www.ubuntume.com/repository $VERSION main #Ubuntu Muslim Edition" >> $SOURCES_TMP
fi

if grep -q "http://siahe.com/zekr/apt" $SOURCES_TMP ; then EXISTS="yes"
else
 	echo "Adding siahe.com repositories to sources.list" 
	echo "#siahe.com" >> $SOURCES_TMP
 	echo "deb http://siahe.com/zekr/apt $VERSION main #siahe.com" >> $SOURCES_TMP
fi

echo "Adding temp main universe restricted multiverse" 
echo "deb http://archive.ubuntu.com/ubuntu/ $VERSION main universe restricted multiverse #temp" >> $SOURCES_TMP

if [ "$VERSION" = "dapper" -o "$VERSION" = "edgy" ]; then
	echo "Uncommenting backports repo in sources.list" 
	if grep -q "#.deb.*backports main restricted universe multiverse" $SOURCES_TMP ; then RECOMMENT="yes"
	else 
	 echo "" > /dev/null
	fi
	sed -i "s|#.deb .*backports main restricted universe multiverse|deb http://archive.ubuntu.com/ubuntu/ $VERSION-backports main restricted universe multiverse|" $SOURCES_TMP
	sed -i "s|#.deb-src.*backports main restricted universe multiverse|deb-src http://archive.ubuntu.com/ubuntu/ $VERSION-backports main restricted universe multiverse|" $SOURCES_TMP
fi

echo "Backing up sources.list" 
cp $SOURCES $SOURCES_BACKUP
mv $SOURCES_TMP $SOURCES
chown root:root $SOURCES

#Download gpg key for repos
echo "Downloading GPG keys"
wget -q http://www.ubuntume.com/download/ubuntume.gpg -O- | sudo apt-key add -
#gpg --keyserver-options honor-http-proxy --keyserver pgp.mit.edu --recv-keys D64E21E8
#gpg --export --armor D64E21E8 | sudo apt-key add -
wget -q http://siahe.com/zekr/apt/zekr.debian.gpg -O- | sudo apt-key add -

#Start installation
echo "Installing Ubuntu Muslim Edition. This may take a few minutes depending on connection speed..."
echo "Starting installation" 
aptitude update 
aptitude install -y zekr ttf-me-quran ttf-sil-scheherazade ttf-farsiweb flashplugin-nonfree zekr-quran-translations-en
aptitude install -y ubuntume 

if [ "$RECOMMENT" = "yes" ]; then
 echo "Recommenting backports repo in sources.list" 
 sed -i "s|deb.*backports main restricted universe multiverse|# deb http://archive.ubuntu.com/ubuntu/ $VERSION-backports main restricted universe multiverse|" $SOURCES
else
 echo "" > /dev/null
fi

echo "Installation successful."
echo "Now configuring Ubuntu Muslim Edition..."

echo Do you want to update your GRUB splash and usplash pictures?
read answer
if [ "$answer" = "yes" -o "$answer" = "y" ]; then
	cp -f /usr/share/ubuntume-artwork/grub/medine_moon_right_below.xpm.gz /boot/grub/splashimages
	cp -f --remove-destination /usr/share/ubuntume-artwork/boot/grub/splash.xpm.gz /boot/grub/splash.xpm.gz
	update-alternatives --install /usr/lib/usplash/usplash-artwork.so usplash-artwork.so /usr/lib/usplash/usplash-ubuntuME.so 50
	update-alternatives --set usplash-artwork.so /usr/lib/usplash/usplash-ubuntuME.so	
	update-initramfs -u
	update-grub
	echo Grub splash and usplash pictures updated
fi

echo ""
echo Do you want to change your GDM splash screen?
read answer
if [ "$answer" = "yes" -o "$answer" = "y" ]; then
	gconftool-2 --type string --set /apps/gnome-session/options/splash_image "/usr/share/gdm/themes/UbuntuME/ubuntume-splash.png" > /dev/null
	gconftool-2 --direct --config-source xml:readwrite:/etc/gconf/gconf.xml.defaults --type string --set /apps/gnome-session/options/splash_image "/usr/share/gdm/themes/UbuntuME/ubuntume-splash.png" > /dev/null
	cp /etc/gdm/gdm.conf-custom /etc/gdm/gdm.conf-custom.ubuntume.backup
	cp -f /usr/share/ubuntume-artwork/gdm/gdm.conf-custom /etc/gdm/gdm.conf-custom
	echo GDM splash changed to /usr/share/gdm/themes/UbuntuME/ubuntume-splash.png
fi

echo ""
echo Do you want to change your Theme?
read answer
if [ "$answer" = "yes" -o "$answer" = "y" ]; then
	gconftool-2 --type string --set /desktop/gnome/interface/gtk_theme "HumanME" > /dev/null
	gconftool-2 --direct --config-source xml:readwrite:/etc/gconf/gconf.xml.defaults --type string --set /desktop/gnome/interface/gtk_theme "HumanME" > /dev/null
	echo Theme changed to "HumanME"

	gconftool-2 --type string --set /apps/metacity/general/theme "HumanME" > /dev/null
	gconftool-2 --direct --config-source xml:readwrite:/etc/gconf/gconf.xml.defaults --type string --set /apps/metacity/general/theme "HumanME" > /dev/null
	echo Metacity theme changed to "HumanME"

	gconftool-2 --type string --set /desktop/gnome/interface/icon_theme "HumanME-green" > /dev/null
	gconftool-2 --direct --config-source xml:readwrite:/etc/gconf/gconf.xml.defaults --type string --set /desktop/gnome/interface/icon_theme "HumanME-green" > /dev/null
	echo Icon theme changed to "HumanME-green"
fi

echo ""
echo Do you want to change your wallpaper?
read answer
if [ "$answer" = "yes" -o "$answer" = "y" ]; then
	gconftool-2 --type string --set /desktop/gnome/background/picture_filename "/usr/share/ubuntume-artwork/ubuntuME.jpg" > /dev/null
	gconftool-2 --type string --set /desktop/gnome/background/picture_options "stretched" > /dev/null
	gconftool-2 --direct --config-source xml:readwrite:/etc/gconf/gconf.xml.defaults --type string --set /desktop/gnome/background/picture_filename "/usr/share/ubuntume-artwork/ubuntuME.jpg" > /dev/null
	gconftool-2 --direct --config-source xml:readwrite:/etc/gconf/gconf.xml.defaults --type string --set /desktop/gnome/background/picture_options "stretched" > /dev/null
	echo Wallpaper changed to /usr/share/ubuntume-artwork/ubuntuME.jpg
fi

if [ "$VERSION" = "gutsy" ]; then 
	echo ""
else
	echo ""
	echo Do you want to change your Firefox toolbar theme?
	read answer
	if [ "$answer" = "yes" -o "$answer" = "y" ]; then
		mv /usr/lib/firefox/chrome/classic/skin/classic/browser/Toolbar.png /usr/lib/firefox/chrome/classic/skin/classic/browser/Toolbar-backup.png 
		cp -f /usr/share/ubuntume-artwork/firefox/Toolbar.png /usr/lib/firefox/chrome/classic/skin/classic/browser/Toolbar.png
		echo Firefox toolbar updated
	fi
fi

echo ""
echo Do you want to configure your screensaver?
read answer
if [ "$answer" = "yes" -o "$answer" = "y" ]; then
	cp -f /usr/share/ubuntume-artwork/glslideshow.desktop /usr/share/applications/screensavers/glslideshow.desktop
	gconftool-2 --type list --list-type string --set /apps/gnome-screensaver/themes ["screensavers-glslideshow"] > /dev/null
	gconftool-2 --direct --config-source xml:readwrite:/etc/gconf/gconf.xml.defaults --type list --list-type string --set /apps/gnome-screensaver/themes ["screensavers-glslideshow"]  > /dev/null
	echo Screensaver configured to use glslideshow
fi

echo ""
echo Do you want to update your login sound?
read answer
if [ "$answer" = "yes" -o "$answer" = "y" ]; then
	cp -f --remove-destination /usr/share/ubuntume-artwork/sounds/startup3.wav /usr/share/sounds/startup3.wav
	echo Login sound changed to "/usr/share/sounds/tasmiyah2.wav"
fi

echo ""
echo "Do you want to install Dansguardian and Tinyproxy and configure them to filter web content? (required to use WCC, the Web Content Control tool)"
read answer
if [ "$answer" = "yes" -o "$answer" = "y" ]; then
	#apt-get --purge remove --assume-yes "dansguardian"
	#apt-get --purge remove --assume-yes "tinyproxy"
	#apt-get --purge remove --assume-yes "clamav"
	apt-get install --assume-yes "oidentd"
	apt-get install --assume-yes "clamav"
	apt-get install --assume-yes "tinyproxy"
	apt-get install --assume-yes "dansguardian"

	#blacklists
	rm -rf /etc/dansguardian/blacklists
	wget http://squidguard.shalla.de/Downloads/shallalist.tar.gz
	tar xzf shallalist.tar.gz -C /etc/dansguardian
	mv /etc/dansguardian/BL /etc/dansguardian/blacklists
	rm -f shallalist.tar.gz
	chown -R root:root /etc/dansguardian/blacklists
	chmod -R 755 /etc/dansguardian/blacklists

	cp -f /usr/share/WebContentControl/tmp/dansguardian/dansguardian.conf /etc/dansguardian/dansguardian.conf
	cp -f /usr/share/WebContentControl/tmp/dansguardian/dansguardianf2.conf /etc/dansguardian/dansguardianf2.conf
	cp -f /usr/share/WebContentControl/tmp/dansguardian/bannedsitelist /etc/dansguardian/bannedsitelist
	cp -f /usr/share/WebContentControl/tmp/dansguardian/bannedurllist /etc/dansguardian/bannedurllist
	cp -f /usr/share/WebContentControl/tmp/dansguardian/bannedmimetypelist /etc/dansguardian/bannedmimetypelist
	cp -f /usr/share/WebContentControl/tmp/dansguardian/bannedextensionlist /etc/dansguardian/bannedextensionlist
	cp -f /usr/share/WebContentControl/tmp/default/oidentd /etc/default/oidentd
	cp -f /usr/share/WebContentControl/tmp/tinyproxy/tinyproxy.conf /etc/tinyproxy/tinyproxy.conf
	cp -rf /usr/share/WebContentControl/languages /etc/dansguardian
	dpkg-reconfigure dansguardian
	echo Web Content Control configured
fi

echo "Removing temp main universe restricted multiverse" 
sed -i "s|deb http://archive.ubuntu.com/ubuntu/ $VERSION main universe restricted multiverse #temp||" $SOURCES

echo ""
echo "Configuration completed. Alhamdulillah."
echo "You should restart your computer for the new settings to take effect." 

exit 0




